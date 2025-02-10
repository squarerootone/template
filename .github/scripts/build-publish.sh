#!/bin/bash
dirs=$1
errors=()

for dir in $(echo "$dirs"); do
    cd $dir
    echo "Building and publishing for $dir"
    uv venv
    . .venv/bin/activate
    uv pip install -r pyproject.toml --all-extras
    if ! uv build; then
        errors+=("$dir: build failed")
    fi
    if ! uv publish; then
        errors+=("$dir: publish failed")
    fi
    deactivate
    cd -
done

if [ ${#errors[@]} -ne 0 ]; then
    echo "Errors encountered:"
    for error in "${errors[@]}"; do
        echo "$error"
    done
    exit 1
fi
