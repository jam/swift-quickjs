#!/usr/bin/env bash

LATEST_TAG=$(git ls-remote --refs --sort="version:refname" --tags https://github.com/quickjs-ng/quickjs.git | cut -d/ -f3-|tail -n1)
CURRENT_TAG=$(git describe --tags --abbrev=0 2>/dev/null)
CQUICKJS_PATH="Sources/CQuickJS"

# Compare the latest release to the current tag in the repository.
if [ "$LATEST_TAG" != "$CURRENT_TAG" ]; then
    echo "New release available! Updating to $LATEST_TAG."
else
    echo "No updates available."
    exit 0
fi

# Get rid of the old QuickJS source code but preserve directory structure.
rm -rf "$CQUICKJS_PATH" && mkdir -p "$CQUICKJS_PATH"

# Fetch the amalgamted source code from the latest release.
curl -o quickjs.tmp.zip -L "https://github.com/quickjs-ng/quickjs/releases/download/$LATEST_TAG/quickjs-amalgam.zip"

# Extract the source code.
unzip -o quickjs.tmp.zip -d "$CQUICKJS_PATH"
rm quickjs.tmp.zip

# Update the VERSION file with the latest tag.
echo $LATEST_TAG > ./VERSION

# Stage and commit all changes.
git add -A
git commit -m "Automation: Update to QuickJS $LATEST_TAG"

# Tag the commit with the latest version.
git tag -a "$LATEST_TAG" -m "Release $LATEST_TAG"

# Push the changes to the repository, including the new tag.
git push origin main --tags

if [ $? -eq 0 ]; then
    echo "Successfully updated to QuickJS $LATEST_TAG and pushed changes."
else
    echo "Failed to push changes. Please check your repository settings."
    exit 1
fi