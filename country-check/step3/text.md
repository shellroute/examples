Log in:

```sh
shellroute login
```

Follow the CLI prompts. On a first login, the account is created as part of the normal login flow.

In the first routed example below, the country before `--` selects the Shellroute route. The final `US` is only the report label passed to `/root/redirect-check.sh`. The Germany command follows the same pattern with `DE` as the route selector and report label.

Run the saved check through the US:

```sh
shellroute run US -- bash /root/redirect-check.sh US
```

Then run it through Germany:

```sh
shellroute run DE -- bash /root/redirect-check.sh DE
```

Each one-shot `shellroute run` command opens its route, runs the check, and ends that route automatically when the command finishes.

The same helper, method, redirect policy, and default URL are used for all three worked-example runs. The report keeps the actual method and URL on every row so a later check against another endpoint cannot silently mix targets with these Google Store rows.

A different result on one route is useful evidence, but it is not proof that country is the only input. Applications can combine network origin with cookies, account state, headers, query parameters, and other logic.
