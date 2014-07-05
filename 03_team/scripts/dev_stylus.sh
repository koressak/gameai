#!/bin/bash

# runs continuously, watches for file changes and compiles .stylus into CSS file(s)

DIR="$( cd "$( dirname "$0" )" && pwd )/../"

stylus --watch -o $DIR/css $DIR/stylus/game.styl
