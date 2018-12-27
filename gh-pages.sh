#!/bin/bash
set -e

rm -rf gh-pages || exit 0;

mkdir -p gh-pages

# compile JS using Elm
elm make src/Main.elm --output gh-pages/elm.js

cp -R src/assets/ gh-pages/assets
cp src/index.html gh-pages/

# replace ../elm.js to elm.js for path in index.html
sed -i '' 's/\.\.\///g' gh-pages/index.html

# init branch and commit
cd gh-pages
git init
git add .
git commit -m "Deploying to GH Pages"
git push --force "git@github.com:AntonPuko/shaders-explore.git" master:gh-pages
