#!/bin/bash
# Verify Step 2: the report holds a direct worked-example row: route "direct",
# proxy_env "no", method HEAD, the Google Store URL. Any status counts,
# including a transport error; this checks that the check was run, not what
# the site answered. Reads the report only; never runs learner commands.
R="${P22_REPORT:-/root/redirect-report.tsv}"
[ -f "$R" ] || exit 1
awk -F'\t' '$1 == "direct" && $3 == "no" && $6 == "HEAD" && $7 == "https://store.google.com/" { found = 1 } END { exit found ? 0 : 1 }' "$R"
