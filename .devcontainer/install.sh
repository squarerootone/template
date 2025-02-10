#!/bin/bash

echo "Instance started, installing initial scripts"

# Specify the line to add to .bashrc
LINE_TO_ADD="GOOGLE_APPLICATION_CREDENTIALS=$(eval echo $GOOGLE_APPLICATION_CREDENTIALS)"

# Check if the line is already present in .bashrc
if ! grep -qF "$LINE_TO_ADD" ~/.bashrc; then
    echo "Adding line to .bashrc"
    echo "$LINE_TO_ADD" >> ~/.bashrc
    echo "Line added to .bashrc"
else
    echo "Line already present in .bashrc"
fi

# Install GH Copilot CLI
gh extension install github/gh-copilot
echo "gh copilot $(gh copilot --version) installed"
# curl -sSL https://github.com/github/copilot-cli/releases/latest/download/copilot-linux -o /usr/local/bin/copilot && chmod +x /usr/local/bin/copilot

# Install uv and devtools
pip install uv
uv pip install --system -r ./.devcontainer/devtools.txt

# Install uv config
mkdir -pv ~/.config/uv
cp ./.devcontainer/uv.toml ~/.config/uv/uv.toml

# Install pre-commit hooks
if [ -f .git/hooks/pre-commit ]; then
    echo "pre-commit hooks already installed"
else
    echo "Installing pre-commit hooks"
    pre-commit install
    echo "pre-commit hooks installed"
fi
