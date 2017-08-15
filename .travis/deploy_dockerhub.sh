#!/bin/sh
docker login -u $DOCKER_USER -p $DOCKER_PASS
if [ "$TRAVIS_BRANCH" = "master" ]; then
    TAG="latest"
else
    TAG="$TRAVIS_BRANCH"
fi

repo_name=$(echo "$TRAVIS_REPO_SLUG" | tr '[:upper:]' '[:lower:]')
repo_name_full=$(echo "$TRAVIS_REPO_SLUG:$TAG" | tr '[:upper:]' '[:lower:]')

docker build -f Dockerfile -t $repo_name_full .
docker push $repo_name