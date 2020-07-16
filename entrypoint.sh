#!/bin/bash
set -e

if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "The GITHUB_TOKEN is required."
    exit 1
fi

cd "$GITHUB_WORKSPACE"

set +e
OUTPUT=$(black --check .)
SUCCESS=$?
if [ $SUCCESS -eq 0 ]; then
    OUTPUT=$(flake8)
    SUCCESS=$?
fi
echo "$OUTPUT"
set -e

if [ $SUCCESS -ne 0 ]; then
  PAYLOAD=$(echo '{}' | jq --arg body "$OUTPUT" '.body = $body')
  COMMENTS_URL=$(jq -r .pull_request.comments_url /github/workflow/event.json)
  echo "$PAYLOAD"
  echo "$COMMENTS_URL"
  curl -s -S -H "Authorization: token $GITHUB_TOKEN" --header "Content-Type: application/json" --data "$PAYLOAD" "$COMMENTS_URL" > /dev/null
else
  echo "There were no pycodestyle issues"
fi
exit $SUCCESS
