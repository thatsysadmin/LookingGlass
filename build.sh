#!/bin/sh

git submodule update --init --recursive
mkdir client/build
cd client/build
cmake ../
make -j2

sh /LookingGlass/gen-rpm.sh