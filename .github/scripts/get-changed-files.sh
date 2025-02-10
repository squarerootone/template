#!/bin/bash

# Set default values for GITHUB environment variables if not set
GITHUB_OUTPUT=${GITHUB_OUTPUT:-".github/output/changed-dirs.txt"}

# Create the GITHUB_OUTPUT file if it does not exist
if [ ! -f "$GITHUB_OUTPUT" ]; then
    mkdir -p "$(dirname "$GITHUB_OUTPUT")"
    touch "$GITHUB_OUTPUT"
fi

# Handle dubious ownership error
git config --global --add safe.directory /__w/libs/libs

# Parse named and positional arguments
DIRECTORY_FILTER=""
EXCLUDE_FILTERS=()
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --directory)
      DIRECTORY_FILTER="$2"
      shift 2
      ;;
    --exclude)
      EXCLUDE_FILTERS+=("$2")
      shift 2
      ;;
    *)
      # Positional argument
      if [ -z "$DIRECTORY_FILTER" ]; then
        DIRECTORY_FILTER="$1"
      else
        EXCLUDE_FILTERS+=("$1")
      fi
      shift
      ;;
  esac
done

# Initialize variables for comparison points
base_ref=""
head_ref=""

# Scenario 1: Local changes compared to origin/development
if [ -z "$GITHUB_EVENT_NAME" ]; then
    echo "Setting comparison points for local changes compared to origin/development"
    git fetch origin development
    base_ref="origin/development"
    head_ref="HEAD"

# Scenario 2: Remote PR changes compared to the latest base branch
elif [ "$GITHUB_EVENT_NAME" = "pull_request" ]; then
    base_branch=$(jq -r .pull_request.base.ref "$GITHUB_EVENT_PATH")
    head_branch=$(jq -r .pull_request.head.ref "$GITHUB_EVENT_PATH")
    echo "Setting comparison points for changes between $base_branch and $head_branch"
    git fetch origin $base_branch
    git fetch origin $head_branch
    base_ref="origin/$base_branch"
    head_ref="origin/$head_branch"

# Scenario 3: Remote push with >=1 commit
else
    branch_name=$(echo $GITHUB_REF | sed 's|refs/heads/||')
    git fetch origin $branch_name
    # TODO make this dynamic - Check changes in the last 5 commits on the dev branch
    if [ "$branch_name" = "main" ] || [ "$branch_name" = "stage" ]; then
        last_commit=$(git rev-parse HEAD~1)
    else
        last_commit=$(git rev-parse HEAD~5)
    fi
    echo "Setting comparison points for changes in $branch_name branch after the push vs before the push"
    base_ref="$last_commit"
    head_ref="origin/$branch_name"
fi

if [ -z "$base_ref" ] || [ -z "$head_ref" ]; then
    echo "Error: Unable to determine base or head branch from event data."
    exit 1
fi

# Output the changed subdirectories
if [ -n "$DIRECTORY_FILTER" ]; then
    changed_files=$(git diff --name-only $base_ref $head_ref | grep "^$DIRECTORY_FILTER/")
    changed_dirs=$(echo "$changed_files" | sed "s|^$DIRECTORY_FILTER/||" | awk -v filter="$DIRECTORY_FILTER" -F'/' '{if (NF > 1) print filter"/"$1}' | sort | uniq)
else
    changed_files=$(git diff --name-only $base_ref $head_ref)
    changed_dirs=$(echo "$changed_files" | awk -F'/' '{if (NF > 1) print $1}' | sort | uniq)
fi

if [ ${#EXCLUDE_FILTERS[@]} -gt 0 ]; then
    for exclude in "${EXCLUDE_FILTERS[@]}"; do
        changed_dirs=$(echo "$changed_dirs" | tr ' ' '\n' | grep -v "^$exclude" | tr '\n' ' ')
    done
fi
changed_dirs=$(echo "$changed_dirs" | xargs)

echo "dirs=$changed_dirs" >> $GITHUB_OUTPUT
