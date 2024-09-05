#!/usr/bin/bash

RED='\033[0;31m'
NC='\033[0m' # No Color

if git diff-index --quiet HEAD; then
  git push -f
  BRANCH=$(git rev-parse --abbrev-ref HEAD)

  ssh HOST /bin/bash << EOF
    cd data
    git checkout ./
    git clean -fd
    git stash
    git stash drop
    git checkout $BRANCH
    git push -f
EOF
else
   echo -e "${RED} Have uncommit changes !!! ${NC}"
fi

