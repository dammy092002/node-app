#!/bin/bash
sed "s/buildNumber/$1/g" pods.yml > node-app-pod.yml
