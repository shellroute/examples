#!/bin/bash
# Verify Step 3: the report holds worked-example rows for both routes: "US"
# and "DE" with proxy_env "yes" (the command ran under a route), method
# HEAD, the Google Store URL. Any status counts. Reads the report only; never
# runs learner commands.
R="${P22_REPORT:-/root/redirect-report.tsv}"
[ -f "$R" ] || exit 1
awk -F'\t' '
  $3 == "yes" && $6 == "HEAD" && $7 == "https://store.google.com/" { if ($1 == "US") us = 1; if ($1 == "DE") de = 1 }
  END { exit (us && de) ? 0 : 1 }' "$R"
