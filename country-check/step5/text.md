The Google Store comparison above is the required worked exercise.

The following commands are an optional transfer pattern for an endpoint you own or are authorized to test. Replace the placeholder URL before running them.

For a case where HEAD is representative:

```sh
bash /root/redirect-check.sh direct 'https://YOUR_APP.example/checkout'
shellroute run US -- bash /root/redirect-check.sh US 'https://YOUR_APP.example/checkout'
shellroute run DE -- bash /root/redirect-check.sh DE 'https://YOUR_APP.example/checkout'
bash /root/redirect-check.sh report
```

Because each report row includes `method` and `url`, these optional rows remain distinguishable from the Google Store rows even though they use the same report file.

### Match the request method to the real bug

The helper uses HEAD because the worked example only needs the response status and first redirect target.

Some applications handle HEAD differently from GET.

If the reported problem happens on a page load, checkout request, API call, or authenticated action, use the request shape that actually reproduces it. Keep the method and other request inputs the same across the route comparison.

### Reuse an existing browser request instead of rebuilding it

If the bug depends on browser state, use browser developer tools:

1. Open *Network*.
2. Reproduce the request.
3. Select the relevant request.
4. Choose *Copy as cURL*.

Inspect the copied command before using it. It can contain cookies, authorization headers, or other sensitive values. Use a test account where appropriate and do not publish secrets or private responses.

Run the copied request directly, then run the same copied request through the country routes you want to compare.

Preserve its method, headers, cookies, body, and query parameters between runs. If you are investigating the first redirect, do not automatically follow it.

This is usually more useful than reconstructing an “equivalent” request by hand, because the copied request preserves the inputs that may be part of the bug.
