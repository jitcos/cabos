#!/usr/bin/env bash

set -oue pipefail

RECIPE_FILE="${1-config/recipe.yml}"
CONTAINERFILE="${2-out.Containerfile}"
CONFIG_DIRECTORY="${3-config/}"

IMAGE_NAME="$(yq '.name' "$RECIPE_FILE")"
BASE_IMAGE="$(yq '.base-image' "$RECIPE_FILE")"
IMAGE_VERSION="$(yq '.image-version' "$RECIPE_FILE")"

echo "Building $CONTAINERFILE for $IMAGE_NAME from $RECIPE_FILE $BASE_IMAGE:$IMAGE_VERSION."

MODULE_DIRECTORY="/tmp/modules"
echo "FROM $BASE_IMAGE:$IMAGE_VERSION" > "$CONTAINERFILE"
echo "
COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq
COPY cosign.pub /usr/share/ublue-os/cosign.pub
COPY --from=ghcr.io/ublue-os/bling:latest /rpms /tmp/bling/rpms/
COPY --from=ghcr.io/ublue-os/bling:latest /files /tmp/bling/files/
COPY --from=ghcr.io/ublue-os/bling:latest /modules /tmp/modules/
COPY modules /tmp/modules/
COPY config /tmp/config/
" >> "$CONTAINERFILE"
echo "
ENV IMAGE_NAME=$IMAGE_NAME
ENV BASE_IMAGE=$BASE_IMAGE
ENV CONFIG_DIRECTORY=\"/tmp/config\"
ENV OS_VERSION=\"\$(grep -Po '(?<=VERSION_ID=)\d+' /usr/lib/os-release)\"
" >> "$CONTAINERFILE"

add_module() {
    MODULE="$1"
    TYPE=$(echo "$MODULE" | yq '.type')
    if [[ "$TYPE" != "null" ]]; then
        # If type is found, that means that the module config
        # has been declared inline, and thus is safe to pass to the module
        # shellcheck disable=SC2028
        echo "echo \"=== Launching module of type: $TYPE ===\" \n\\
        bash \"$MODULE_DIRECTORY/$TYPE/$TYPE.sh\" '$(echo "$MODULE" | tr -d '\n')' \n\\
        echo \"======\" \n\\"
    else
        # If the type is not found, that means that the module config
        # is in a separate file, and has to be read from it
        FILE=$(echo "$MODULE" | yq '.from-file')
        add_modules "$CONFIG_DIRECTORY/$FILE"
    fi
}

add_modules() {
    MODULES_FILE="$1"
    readarray MODULES < <(yq -o=j -I=0 '.modules[]' "$MODULES_FILE" )
    if [[ ${#MODULES[@]} -gt 0 ]]; then
        for MODULE in "${MODULES[@]}"; do
            add_module "$MODULE"
        done
    else
        MODULE=$(yq -o=j -I=0 '.' "$MODULES_FILE")
        add_module "$MODULE"
    fi
}

# shellcheck disable=SC2028
echo "RUN printf '\
#!/usr/bin/env bash \n\
set -oue pipefail \n\
get_yaml_array() { \n\
    readarray "\$1" < <(echo "\$3" | yq -I=0 "\$2") \n\
} \n\
export -f get_yaml_array \n\
$(add_modules "$RECIPE_FILE") 
echo "Done!"' \
> /tmp/build.sh" >> "$CONTAINERFILE"

echo "RUN chmod +x /tmp/build.sh && /tmp/build.sh && \
    rm -rf /tmp/* /var/* && ostree container commit" >> "$CONTAINERFILE"
