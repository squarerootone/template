#!/bin/bash
dirs=$1
errors=()

for dir in $(echo "$dirs"); do
    echo "Linting, formating and testing for $dir"
    if [ ! -r $dir ] || [ ! -x $dir ]; then
        echo "Permission denied for $dir"
        continue
    fi
    cd $dir
    uv venv
    . .venv/bin/activate
    uv pip install -r pyproject.toml --all-extras
    if ! ruff check . --fix --output-format=github; then
        errors+=("$dir: ruff check failed")
    fi
    if ! ruff format .; then
        errors+=("$dir: ruff format failed")
    fi
    if ! pytest 2>/dev/null || [ $? -eq 5 ]; then
        echo "No tests found or pytest not available for $dir"
    elif ! pytest; then
        errors+=("$dir: pytest failed")
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
