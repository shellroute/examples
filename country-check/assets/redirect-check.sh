#!/bin/bash
# redirect-check.sh: record one HTTP check for a redirect investigation.
#
#   bash redirect-check.sh <route-label> [url]     run the check, append one row
#   bash redirect-check.sh report                  print the table
#
# Default url: https://store.google.com/  (the request from the published articles)
# Report file: $REPORT, default /root/redirect-report.tsv
#
# Row fields, tab separated: route, utc_time, proxy_env, status,
# first_location_or_error, method, url. The method is always HEAD here; the url
# is the one actually requested, so rows for different targets never mix.
#
# The request is the same every time: HEAD (-I), no redirect following (no -L),
# 15 second limit. The row records when it ran, whether a proxy was set in the
# environment, the target's HTTP status, and the first Location header of the
# target's final response. Nothing is interpreted here; you read the table.
#
# proxy_env=yes means HTTPS_PROXY (or https_proxy) was set when the check ran;
# shellroute run sets it for the command. It says nothing about which exit or
# country the request used. The status and Location are the evidence.
#
# Through an HTTP proxy, curl first receives the proxy's own "200 Connection
# established" reply, and some servers send 1xx informational replies before
# the real one. --suppress-connect-headers drops the proxy reply, and the parser
# reads the last response block, so the row always shows the target's answer.
#
# A curl failure (DNS, connection, timeout) is recorded as a transport error with
# curl's message. An HTTP 4xx or 5xx is a response and is recorded as its status.
set -u

REPORT="${REPORT:-/root/redirect-report.tsv}"
DEFAULT_URL="https://store.google.com/"

if [ "${1:-}" = "report" ]; then
  if [ ! -f "$REPORT" ]; then
    echo "no report yet: $REPORT"
    exit 1
  fi
  awk -F'\t' '{ printf "%-8s  %-20s  %-9s  %-15s  %-6s  %-32s  %s\n", $1, $2, $3, $4, $6, $7, $5 }' "$REPORT"
  exit 0
fi

LABEL="${1:?usage: redirect-check.sh <route-label> [url]   or   redirect-check.sh report}"
URL="${2:-$DEFAULT_URL}"
METHOD="HEAD"
TS=$(date -u +%Y-%m-%dT%H:%M:%SZ)

if [ -n "${HTTPS_PROXY:-}" ] || [ -n "${https_proxy:-}" ]; then
  PROXY_ENV="yes"
else
  PROXY_ENV="no"
fi

HEADERS=$(mktemp)
ERRORS=$(mktemp)
curl -sS -I --max-time 15 --suppress-connect-headers -o /dev/null -D "$HEADERS" "$URL" 2>"$ERRORS"
RC=$?

if [ "$RC" -ne 0 ]; then
  STATUS="transport error"
  DETAIL="curl exit $RC: $(head -1 "$ERRORS" | sed 's/^curl: //')"
else
  # Last response block wins: a status line starts a block and clears the
  # Location seen so far, so proxy and 1xx blocks before the final answer are
  # skipped. The first Location inside the final block is kept.
  PARSED=$(tr -d '\r' < "$HEADERS" | awk '
    /^HTTP\// { status = $2; loc = ""; next }
    tolower($0) ~ /^location:/ && loc == "" { sub(/^[Ll][Oo][Cc][Aa][Tt][Ii][Oo][Nn]:[ \t]*/, ""); loc = $0 }
    END { print status "\t" loc }')
  STATUS="${PARSED%%	*}"
  DETAIL="${PARSED#*	}"
  [ -z "$STATUS" ] && STATUS="(no status line)"
  [ -z "$DETAIL" ] && DETAIL="(no Location header)"
fi
rm -f "$HEADERS" "$ERRORS"

if [ ! -f "$REPORT" ]; then
  printf 'route\tutc_time\tproxy_env\tstatus\tfirst_location_or_error\tmethod\turl\n' > "$REPORT"
fi
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$LABEL" "$TS" "$PROXY_ENV" "$STATUS" "$DETAIL" "$METHOD" "$URL" | tee -a "$REPORT"
