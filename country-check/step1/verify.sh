#!/bin/bash
# Verify Step 1: the CLI the learner installed answers. No network, no login.
command -v shellroute >/dev/null 2>&1 || exit 1
shellroute --version >/dev/null 2>&1
