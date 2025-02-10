STAGE_TYPE=${1:-$STAGE_TYPE}
echo $STAGE_TYPE
if [ -z "$STAGE_TYPE" ]; then
    echo "Error: STAGE_TYPE is not set."
    exit 1
fi

mkdir -pv ~/.config/uv
cp ./.devcontainer/uv.toml ~/.config/uv/uv.toml

if [ "$STAGE_TYPE" = "prod" ]; then
    registry="quilt-platform/quilt-python"
elif [ "$STAGE_TYPE" = "stg" ]; then
    registry="quilt-platform-dev/quilt-python-stg"
else
    registry="quilt-platform-dev/quilt-python-dev"
fi
echo $registry

sed -i "s|quilt-platform-dev/quilt-python-dev|$registry|" ~/.config/uv/uv.toml
cat ~/.config/uv/uv.toml
