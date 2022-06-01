#!/bin/bash

projects=(
)

GIT_TERMINAL_PROMPT=0
echo $GIT_TERMINAL_PROMPT

for project in "${projects[@]}"
do
  IFS=/ read owner project_name <<< $project
  
  echo $project_name

  git clone --quiet "git@github.com:$project.git" --depth=1
  if [ $? -eq 0 ]; then
    clone_result="true"
  else
    echo "$project" >> repos_clone_error.txt
    sleep 3
    continue
  fi

  cd $project_name

  if [ -e package-lock.json ]
  then
    package_lock_exists="true"
  else
    package_lock_exists="false"
  fi

  if [ -e yarn.lock ]
  then
    yarn_lock_exists="true"
  else
    yarn_lock_exists="false"
  fi


  echo "$project, $package_lock_exists, $yarn_lock_exists, $(cat package.json | jq --raw-output -c '[.name, .license] | @csv')" >> ../result.csv

  cd ..
  rm -rf $project_name

  sleep 3
done
