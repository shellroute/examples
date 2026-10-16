A report like “our store redirects to the wrong regional page” is hard to debug from a screenshot alone.

A better question is:

What does the same HTTP request return when the network route changes?

This lesson uses [store.google.com](https://store.google.com/) as a public worked example because redirects are easy to inspect without following them. The exact response is not fixed. Google can change its redirect behavior, and a route can be classified differently over time.

The sandbox includes `/root/redirect-check.sh`. It sends one bounded HEAD request and appends a tab-separated row to `/root/redirect-report.tsv`.

Each row records:

- route label;
- UTC time;
- `proxy_env`, which is `yes` when `HTTPS_PROXY` or `https_proxy` was configured for that command and `no` otherwise;
- HTTP status, or `transport error`;
- first `Location` header, or the curl error detail;
- method, which is `HEAD` in this helper;
- URL actually requested.

`proxy_env=yes` does not prove that the request used a particular proxy, exit, or country. It only records that those proxy variables were present in the command environment.

That gives you a compact report you can compare and later reuse against an authorized endpoint you are actually debugging.
