#!/bin/bash

# ----- Install jazzy

git clone --depth 1 --branch integrated-markdown https://github.com/agentk/jazzy/
cd jazzy
bundle install
cd ..

# ----- Build master
if [ -d ReduxKit ]; then
  git -C ReduxKit pull origin master
else
  git clone --depth 1 --branch master https://github.com/ReduxKit/ReduxKit.git ReduxKit
fi

./jazzy/bin/jazzy --config .jazzy.json --clean --output master --module-version "master"
