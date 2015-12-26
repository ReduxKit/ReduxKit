#!/bin/bash

# ----- Clone
if [ -d ReduxKit ]; then
  git -C ReduxKit pull origin master
else
  git clone --depth 1 --branch master https://github.com/ReduxKit/ReduxKit.git ReduxKit
fi

# ----- Jazzy
VERSION=`grep "s.version" ReduxKit/ReduxKit.podspec | cut -d '"' -f2`
jazzy --config .jazzy.json --module-version "$VERSION"

# ----- Gitbook
gitbook install
gitbook build ReduxKit tmp
rm -rf gitbook
mv tmp/{*.html,*.json,gitbook} ./
rm -rf tmp
