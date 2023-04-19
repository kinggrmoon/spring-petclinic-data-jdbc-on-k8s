#!/bin/bash

if [ -z "$1" ]; then
    VERSION="latest"
else
    VERSION=$1
fi

# clean 명령을 실행합니다.
./mvnw clean

# package 명령을 실행합니다.
./mvnw package

# Docker 이미지 빌드
docker build -t app:${VERSION} .