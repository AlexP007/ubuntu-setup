#!/usr/bin/bash

git checkout master
ssh HOST /bin/bash << EOF
  cd data
  git checkout ./
  git clean -fd
  git stash
  git stash drop
  git checkout master
  git pull origin master
EOF
git pull -f
