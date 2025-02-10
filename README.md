Placeholder for sonarcloud

## Contributing
Refer [Contributing Guide](./CONTRIBUTING.md)

## Package List

## Directory structure

## Changelog
Refer [CHANGELOG](./CHANGELOG.md)

## TODO
- set up Sonarcloud, sonarlint
- set up gh actions to run on PR, push, tag
- set up pre-commit
- set up environment variables at repo / org level
- set up unit test coverage report
- set up instructions for contributing

- only build & publish if linting succeeds
- make changed file dynamic instead of looking for last 1 commit in main stg and 5 in dev
- commit msg linting
- automatic package versioning
- simplify devcontainer?
- run 1 round of pre-commit before linting formating and testing & building
- pre-commit to run tests too
- add makefile convenience, or importing path to run all the scripts automatically
- more instructions on contributing, setting up venv, selecting interpreter, running tests
- need to stop running container as root

- configure auth so can download images (ghcr) locally
- test out using it for devcontainer
- use the scripts for pre-commit hooks
- move the scripts to a common location
- build in triggers to rebuild all libs
- add `git clean -fdX` to the flow
- add the scripts to system path so it can be triggered directly
- new repo that support docker? jupyter? other usage?
- how to publish changes faster? right now gh action would cycle through all the changes sequentially and build & publish

To ensure that under [codespace secrets](https://github.com/settings/codespaces) there is `GH_SSH_KEY` (private key) before startup.

- set up git user.email and user.name as part of install.sh
- figure out the GCP_KEY bit for local env
- to a lesser extent figure out the GH_SSH_KEY bit
- figure out liveshare for local env
- figure out mongodb remote
- install gh copilot CLI
- init the submodules

```shell
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
git submodule update --init $1
gcloud auth configure-docker
```
- https://github.com/tiangolo/uvicorn-gunicorn-docker/blob/master/docker-images/python3.9.dockerfile
- https://github.com/tiangolo/uvicorn-gunicorn-fastapi-docker/blob/master/docker-images/python3.9.dockerfile
