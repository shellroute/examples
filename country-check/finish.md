You now have a redirect investigation you can hand to a developer with:

- the exact request URL and method for every row;
- direct, US, and Germany route labels;
- UTC timestamps;
- configured proxy-environment presence;
- HTTP status for completed HTTP checks;
- the first `Location` header when present;
- incomplete curl checks kept separate as transport errors;
- the next debugging question suggested by the comparison.

The useful result is not that three routes must produce three different redirects.

It is that you can preserve a request, change the network route deliberately, record what actually happened, and use that evidence to decide what to inspect next.
