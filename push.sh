#!/bin/sh

setup_git() {
  git config --global user.email "blademainer@gmail.com"
  git config --global user.name "blademainer"
}

commit_website_files() {
  git checkout -b gh-pages
  git add ./ -A
  git commit --message "Travis build: $TRAVIS_BUILD_NUMBER"
}

upload_files() {
  url="https://{{GH_TOKEN}}@github.com/pjoc-team/pjoc-team.github.io.git"
  git remote add origin-pages $url > /dev/null 2>&1
  git push --quiet --set-upstream origin-pages gh-pages -f
}

rm -fr .git
cd public
git init
setup_git
commit_website_files
upload_files