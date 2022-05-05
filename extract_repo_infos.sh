#!/bin/bash

# Author: Dennis Urtubia
# Code to extract repositories infos (name, stargazers count and forks count)

# FORMAT OF PROJECTS STRING: owner/repo
projects=(
)

for project in "${projects[@]}"
do
  curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/$project" | jq '{name: .name, stars: .stargazers_count, forks: .forks_count}'
done
