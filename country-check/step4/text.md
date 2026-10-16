Print the accumulated report:

```sh
bash /root/redirect-check.sh report
```

The report view shows, for each row:

```text
route  utc_time  proxy_env  status  method  url  first_location_or_error
```

You should now have at least the three worked-example rows labeled `direct`, `US`, and `DE`.

Read the table as evidence, not as a pass/fail scoreboard.

### If the first Location changes

If the same URL and method produce different `Location` values, you have reproduced a response difference while holding the request shape constant.

That is a useful lead, not a complete diagnosis.

For a checkout or locale bug, ask what selected the destination:

- Did the application classify the connection differently?
- Did a saved language or region preference override the network signal?
- Did a cookie or account setting change the branch?
- Did a path, hostname, or earlier redirect rule run first?

The report narrows the investigation. It does not tell you which rule is responsible.

### If one route returns a consent URL

Keep that row.

A consent redirect is application behavior, not a failed test just because it differs from a locale redirect.

Two historical observations in an earlier Shellroute Python article illustrate why this lesson records the actual status and first `Location` instead of hardcoding an expected language value. The article first recorded a locale-specific German Google Store redirect, while a later historical update recorded a German request going to a Google consent page:

[shellroute.hashnode.dev/reproduce-a-python-http-request-from-another-country](https://shellroute.hashnode.dev/reproduce-a-python-http-request-from-another-country)

The next question is whether your own application has a similar gate before the regional redirect you expected.

### If all three rows are unchanged

An unchanged result is also evidence.

Do not conclude from one comparison that network origin is irrelevant.

First verify that the HTTP client and command setup are appropriate for the route you intended to test. Then consider whether the real behavior depends on another input such as a cookie, account state, request method, header, query parameter, or body.

The goal is to preserve the request and interpret what actually happened, not to force the rows to differ.

### If the report shows an HTTP 4xx or 5xx

Treat it as an HTTP response.

Record the status and any `Location` header exactly as returned.

That is different from an incomplete curl check, but it does not by itself prove which backend or origin generated the response.

### If the report shows transport error

A nonzero curl result means this check did not complete normally.

The row keeps curl’s exit code and error text so DNS, connection, TLS, timeout, or proxy/client handling can be investigated separately from redirect behavior.

Do not interpret that row as an application redirect result.
