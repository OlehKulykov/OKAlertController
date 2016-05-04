#!/bin/bash

echo -e "Executing docs"

if [ "$TRAVIS_PULL_REQUEST" == "false" ] && [ "$TRAVIS_BRANCH" == "master" ]; then
    echo -e "Generating Jazzy output \n"
    
    jazzy --clean --module-version 1.0.5 --author "Oleh Kulykov" --author_url http://www.resident.name --github_url https://github.com/OlehKulykov/OKAlertController --xcodebuild-arguments "-scheme,OKAlertController" --module OKAlertController --root-url http://olehkulykov.github.io/OKAlertController --theme apple --swift-version 2.2 --min-acl public --readme README.md

    pushd docs

    echo -e "Creating gh-pages\n"
    git init
    git config user.email ${GIT_EMAIL}
    git config user.name ${GIT_NAME}
    git add -A
    git commit -m "Documentation from Travis build of $TRAVIS_COMMIT"
    git push --quiet --force "https://${GH_TOKEN}@github.com/OlehKulykov/OKAlertController.git" master:gh-pages > /dev/null 2>&1
        
    echo -e "Published documentation to gh-pages.\n"

    popd
fi
