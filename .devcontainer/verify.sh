#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Checking installation and configuration..."

# Check if SSH is installed
if command -v ssh > /dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}: SSH is installed"
else
    echo -e "${RED}FAIL${NC}: SSH is not installed. Please install SSH."
fi

# Check if Python is installed
EXPECTED_PYTHON_VERSION="3.13.1"
if command -v python3 > /dev/null 2>&1; then
    # Check if Python version is $EXPECTED_PYTHON_VERSION
    PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')
    if [ "$PYTHON_VERSION" == "$EXPECTED_PYTHON_VERSION" ]; then
        echo -e "${GREEN}PASS${NC}: Python version is $EXPECTED_PYTHON_VERSION"
    else
        echo -e "${RED}FAIL${NC}: Python version is not $EXPECTED_PYTHON_VERSION. Current version: $PYTHON_VERSION. Please install Python $EXPECTED_PYTHON_VERSION."
    fi
else
    echo -e "${RED}FAIL${NC}: Python is not installed. Please install Python."
fi

# Check if gcloud CLI is installed
if command -v gcloud > /dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}: gcloud CLI is installed"
else
    echo -e "${RED}FAIL${NC}: gcloud CLI is not installed. Please install gcloud CLI."
fi

# Check if GH_TOKEN environment variable is set and correct
if [ -z "$GH_TOKEN" ]; then
    echo -e "${RED}FAIL${NC}: GH_TOKEN environment variable is not set. Please set it if you need to use gh cli and copilot."
else
    echo -e "${GREEN}PASS${NC}: GH_TOKEN environment variable is set to $GH_TOKEN"
fi

# Check if gh copilot is installed
if gh extension list | grep -q "github/gh-copilot"; then
    echo -e "${GREEN}PASS${NC}: gh copilot is installed"
else
    echo -e "${RED}FAIL${NC}: gh copilot is not installed. Please run 'gh extension install github/gh-copilot'."
fi

# Check if required VSCode extensions are installed
REQUIRED_EXTENSIONS=(
    "ms-vsliveshare.vsliveshare"
    "ms-vscode.remote-repositories"
    "github.remotehub"
    "github.vscode-pull-request-github"
    "github.vscode-github-actions"
    "github.copilot"
    "github.copilot-chat"
    "sonarsource.sonarlint-vscode"
    "mhutchie.git-graph"
)

for extension in "${REQUIRED_EXTENSIONS[@]}"; do
    if code --list-extensions | grep -q "$extension"; then
        echo -e "${GREEN}PASS${NC}: VSCode extension $extension is installed"
    else
        echo -e "${RED}FAIL${NC}: VSCode extension $extension is not installed. Please install it."
    fi
done

# Check if UV_PUBLISH_USERNAME environment variable is set and correct
if [ -z "$UV_PUBLISH_USERNAME" ]; then
    echo -e "${RED}FAIL${NC}: UV_PUBLISH_USERNAME environment variable is not set. Please set it."
elif [ "$UV_PUBLISH_USERNAME" == "oauth2accesstoken" ]; then
    echo -e "${GREEN}PASS${NC}: UV_PUBLISH_USERNAME environment variable is set correctly to oauth2accesstoken"
else
    echo -e "${RED}FAIL${NC}: UV_PUBLISH_USERNAME environment variable is set to $UV_PUBLISH_USERNAME, but it should be set to oauth2accesstoken"
fi

# Check if GOOGLE_APPLICATION_CREDENTIALS environment variable is set and correct
if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    echo -e "${RED}FAIL${NC}: GOOGLE_APPLICATION_CREDENTIALS environment variable is not set. Please set it."
elif [ "$GOOGLE_APPLICATION_CREDENTIALS" == "$HOME/.config/gcloud/application_default_credentials.json" ]; then
    echo -e "${GREEN}PASS${NC}: GOOGLE_APPLICATION_CREDENTIALS environment variable is set correctly to $GOOGLE_APPLICATION_CREDENTIALS"
else
    echo -e "${RED}FAIL${NC}: GOOGLE_APPLICATION_CREDENTIALS environment variable is set to $GOOGLE_APPLICATION_CREDENTIALS, but it should be set to $HOME/.config/gcloud/application_default_credentials.json"
fi

# Check if GOOGLE_APPLICATION_CREDENTIALS is set in .bashrc
if grep -qF "GOOGLE_APPLICATION_CREDENTIALS" ~/.bashrc; then
    echo -e "${GREEN}PASS${NC}: GOOGLE_APPLICATION_CREDENTIALS is set in .bashrc"
else
    echo -e "${RED}FAIL${NC}: GOOGLE_APPLICATION_CREDENTIALS is not set in .bashrc. Please ensure it is added."
fi

# Check if GCP_KEY environment variable is set and correct
if [ -z "$GCP_KEY" ]; then
    echo -e "${RED}FAIL${NC}: GCP_KEY environment variable is not set. Please insert into the file at $GOOGLE_APPLICATION_CREDENTIALS and try ./devcontainer/startup.sh again."
else
    echo -e "${GREEN}PASS${NC}: GCP_KEY environment variable is set to $GCP_KEY"
fi

# Check if GOOGLE_APPLICATION_CREDENTIALS file contains the correct client_email
if grep -q '"client_email": "local-dev@quilt-platform-dev.iam.gserviceaccount.com"' "$GOOGLE_APPLICATION_CREDENTIALS"; then
    echo -e "${GREEN}PASS${NC}: GOOGLE_APPLICATION_CREDENTIALS file contains the correct client_email"
else
    echo -e "${RED}FAIL${NC}: GOOGLE_APPLICATION_CREDENTIALS file does not contain the correct client_email. Please check the file."
fi

# Check if gcloud CLI is authenticated with the correct account
GCLOUD_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format="value(account)")
EXPECTED_ACCOUNT="local-dev@quilt-platform-dev.iam.gserviceaccount.com"

if [ "$GCLOUD_ACCOUNT" == "$EXPECTED_ACCOUNT" ]; then
    echo -e "${GREEN}PASS${NC}: gcloud CLI is authenticated with the correct account: $GCLOUD_ACCOUNT"
else
    echo -e "${RED}FAIL${NC}: gcloud CLI is not authenticated with the correct account. Current account: $GCLOUD_ACCOUNT. Please authenticate with $EXPECTED_ACCOUNT."
fi

# Check if uv is installed
if pip show uv > /dev/null 2>&1; then
    echo -e "${GREEN}PASS${NC}: uv is installed"
else
    echo -e "${RED}FAIL${NC}: uv is not installed. Please run 'pip install uv'."
fi

# Check if devtools are installed
while IFS= read -r tool; do
    tool_name=$(echo "$tool" | cut -d'=' -f1 | cut -d'>' -f1 | cut -d'<' -f1 | awk '{print $1}')
    required_version=$(echo "$tool" | sed "s/$tool_name//")
    required_version=$(if [[ "$required_version" = "" ]]; then echo "Any"; else echo "$required_version"; fi)
    if pip show "$tool_name" > /dev/null 2>&1; then
        installed_version=$(pip show "$tool_name" | grep -i version | awk '{print $2}')
        echo -e "${GREEN}PASS${NC}: $tool_name is installed with version $installed_version. Required version $required_version."
    else
        echo -e "${RED}FAIL${NC}: $tool_name is not installed. Please run 'pip install -r ./.devcontainer/devtools.txt'."
    fi
done < ./.devcontainer/devtools.txt

# Check if uv config is installed
if [ -f ~/.config/uv/uv.toml ]; then
    echo -e "${GREEN}PASS${NC}: uv config is installed"
else
    echo -e "${RED}FAIL${NC}: uv config is not installed. Please ensure the file ./.devcontainer/uv.toml is copied to ~/.config/uv/uv.toml."
fi

# Check if pre-commit hooks are installed
if [ -f .git/hooks/pre-commit ]; then
    echo -e "${GREEN}PASS${NC}: pre-commit hooks are installed"
else
    echo -e "${RED}FAIL${NC}: pre-commit hooks are not installed. Please run 'pre-commit install'."
fi

# Check if the JetBrains IDEA editor is removed
if [ ! -d /workspaces/.codespaces/shared/editors/jetbrains/ ]; then
    echo -e "${GREEN}PASS${NC}: JetBrains IDEA editor is removed"
else
    echo -e "${RED}FAIL${NC}: JetBrains IDEA editor is not removed. Please remove it."
fi

echo "Installation and configuration check complete."

# Check if git user name is set
GIT_USER_NAME=$(git config --global user.name)
if [ -z "$GIT_USER_NAME" ]; then
    echo -e "${RED}FAIL${NC}: Git user name is not set. Please set it using 'git config --global user.name \"Your Name\"'."
else
    echo -e "${GREEN}PASS${NC}: Git user name is set to $GIT_USER_NAME"
fi

# Check if git user email is set
GIT_USER_EMAIL=$(git config --global user.email)
if [ -z "$GIT_USER_EMAIL" ]; then
    echo -e "${RED}FAIL${NC}: Git user email is not set. Please set it using 'git config --global user.email \"your.email@example.com\"'."
else
    echo -e "${GREEN}PASS${NC}: Git user email is set to $GIT_USER_EMAIL"
fi
