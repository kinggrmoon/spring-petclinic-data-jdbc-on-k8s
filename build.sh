#!/bin/bash

#CSS Copy
./gradlew mavenCSS

# build
./gradlew clean build

# make docker image
./gradlew buildDocker