#!/bin/bash

kustomize build manifest/overlays/prod | kubectl -n default apply -f -