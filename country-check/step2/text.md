Start in the ordinary sandbox shell, before logging in to Shellroute:

```sh
bash /root/redirect-check.sh direct
```

The helper uses this request shape:

```sh
curl -sS -I --max-time 15 https://store.google.com/
```

`-I` makes a HEAD request, so the check focuses on response headers.

The helper does not use `-L`. Following redirects would hide the first response you want to compare.

It also suppresses proxy CONNECT headers and reads the target response block rather than mistaking a proxy’s own `200 Connection established` for the site’s response. If informational `1xx` responses appear first, the helper skips them and records the later target response block.

This first run adds a `direct` row to `/root/redirect-report.tsv`.

Do not expect a particular language code, redirect status, or destination.

A `301`, `302`, another `3xx`, `200`, `404`, `500`, or another HTTP status is still an HTTP response. A `404` or `500` proves that curl received an HTTP response, but it does not by itself prove which application component or origin produced it.

If curl exits nonzero, the check did not complete normally. The script records `transport error` with curl’s exit code and error text. That does not prove that no HTTP bytes were ever received. It means the check did not produce a completed HTTP result for this report.

You can inspect the current report at any time:

```sh
bash /root/redirect-check.sh report
```
