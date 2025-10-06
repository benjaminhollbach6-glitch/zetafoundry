.RECIPEPREFIX := >
# Stream latest run logs (fails non-zero if CI failed)
ci-log:
> RUN_ID=$$(gh run list --workflow=ci.yml --branch main -L 1 --json databaseId -q '.[0].databaseId'); \
> test -n "$$RUN_ID" || { echo "no recent runs for ci.yml"; exit 1; }; \
> gh run view "$$RUN_ID" --log --exit-status

# Watch latest run until completion
ci-watch:
> RUN_ID=$$(gh run list --workflow=ci.yml --branch main -L 1 --json databaseId -q '.[0].databaseId'); \
> test -n "$$RUN_ID" || { echo "no recent runs for ci.yml"; exit 1; }; \
> gh run watch "$$RUN_ID" --exit-status

# Rerun only failed jobs of the latest run
ci-rerun-failed:
> gh run rerun --failed "$$(gh run list --workflow=ci.yml --branch main -L 1 --json databaseId -q '.[0].databaseId')"

# Manually trigger; pass DEBUG_VERSIONS=1 to enable the optional step
ci-dispatch:
> gh workflow run ci.yml -f debug_versions=$${DEBUG_VERSIONS-0} >/dev/null || gh workflow run ci.yml >/dev/null; \
> echo "dispatched workflow ci.yml on branch main"
