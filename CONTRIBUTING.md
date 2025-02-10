## Setting up local dev environment

In general your dev environment is set up for you in 3 ordered steps

1. [`devcontainer.json`](.devcontainer/devcontainer.json) specifies a set of packages and vsc extensions to install
2. [`install.sh`](.devcontainer/install.sh) specifies more packages to install
3. [`startup.sh`](.devcontainer/startup.sh) log into gcp service account and perform any other tricks

You can run [`verify.sh`](.devcontainer/verify.sh) to check your installation if anything is missing

The recommended way is to use [codespace](https://docs.github.com/en/codespaces), a virtual environment running in azure cloud that can be spin up at any time, with a clean install of everything, so basically a rest environment. If you're using this, all installations should (hopefully) successfully run at build time and taken care of.

However, codespace's free quota is 120 core hours / month, at a minimum 2-core (i.e. max 60h free). You'll likely need to go to the local alternative [devcontainer](https://code.visualstudio.com/docs/remote/container), which is using exactly the same set up instructions as codespace, except some missing environment variables that github automatically inject into codespace (you can inject your own while building the container, but it's not straightforward). If you're doing this, then likely
- step 1 is done, but might miss out on `GCP_KEY, GH_TOKEN` env, which means you will not be automatically logged into gcloud and gh cli
- you can manually create the json file by running `nano $GOOGLE_APPLICATION_CREDENTIALS` then log in by `./.devcontainer/startup.sh`
- step 2 & 3 should run correctly
- git will also not be automatically configured with your name and email, so you will need to run this as well
```
git config --global user.name "[name]"
git config --global user.email "[email]"
```

Finally, if you prefer to use your existing dev environment, you can run `./.devcontainer/verify.sh` or manually inspect all 3 steps and install the missing requirements yourself.
- ensure you're on the correct python version
- set up gcp key file
- run `./.devcontainer/install.sh` to install a bunch of tools and configure uv

## Git strategy
- `main` for production codes, `stage, dev` for non-prod
- Branch out from `dev`, then PR and squash merge to dev when ready.
- Commit merge to `stage, main` when ready

## 

## Common commands
```bash
# For venv
uv venv  # to create a virtual environment in current folder
source .venv/bin/activate  # to activate the venv
deactivate  # to exit the venv

# For standard project usage
uv sync  #
uv add [package]  # add a package to pyproject.toml
uv lock  # create the uv.lock file
uv lock --upgrade-package [package]  # upgrade a particular package in uv.lock file
uv pip install -r pyproject.toml --extra dev  # install all dependencies + dev dependencies
uv pip install -r pyproject.toml --all-extras  # install all dependencies and all optional dependencies
pytest  # run unit tests

# For version control
pre-commit run --all-files  # run the pre-commit hooks on all files
git clean -fdX  # remove all gitignored files and reset the environment

# For publishing
uv build  # build the package in ./dist folder
uv publish  # publish to the configured index / repository / registry
```