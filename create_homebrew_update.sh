#!/bin/bash
#
# To create updated branch from gh/homebrew
# Useful when you update regularly any formula
#
# Need to have homebrew forked previously
#
# Alexandre Espinosa Menor - https://github.com/alexandregz
#

REPO_PATH="/tmp"
MY_USER="alexandregz"

NEW_BRANCH="galen"  # eg.
NEW_VERSION="1.5.3"

ICON="\xF0\x9F\x8D\xBA "

clone() {
  echo -e "$ICON CLONANDO..."
  git clone https://github.com/$MY_USER/homebrew $REPO_PATH/homebrew
}

cdHomebrew() {
  echo -e "$ICON cd homebrew"
  cd $REPO_PATH/homebrew
}

sync() {
  # add upstream and sync my fork
  echo -e "$ICON syncing..."
  git remote add upstream https://github.com/homebrew/homebrew
  git remote -v
  git fetch upstream
  git merge upstream/master
}

checkout() {
  echo -e "$ICON new branch"
  git checkout -b $NEW_BRANCH
}

cpNewFormula() {
  # new branch must be recipe name
  echo -e "$ICON cp $NEW_BRANCH.rb"
  cp $(brew --prefix)/Library/Formula/$NEW_BRANCH.rb Library/Formula/
}

gitAddAndCommit() {
  echo -e "$ICON add and commit"
  git add Library/Formula/$NEW_BRANCH.rb
  git commit -m "$NEW_BRANCH $NEW_VERSION"
}

gitPush() {
  echo -e "$ICON and push!"
  git push -u origin $NEW_BRANCH
}


usage() {
  echo "Usage: $0 [--clone] [--sync] [--checkout] [--cp] [--commit] [--push]"
  echo "  clone:     clone Homebrew"
  echo "  sync:      sync fork"
  echo "  checkout:  checkout new branch"
  echo "  cp:        copy formula from (brew --prefix)"
  echo "  commit:    commit with msg 'FORMULA VERSION' (standard msg to update formula)"
  echo "  push:      push to new branch"
}



if [[ $# -eq 0 ]]; then
  usage
fi


while test $# -gt 0
do
    case "$1" in
        --clone) clone
            ;;
        --sync) cdHomebrew && sync
            ;;
        --checkout) cdHomebrew && checkout
            ;;
        --cp) cdHomebrew && cpNewFormula
            ;;
        --commit) cdHomebrew && gitAddAndCommit
            ;;
        --push) cdHomebrew && gitPush
            ;;

        *) usage
            ;;
    esac
    shift
done
