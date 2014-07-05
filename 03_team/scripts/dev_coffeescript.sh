#!/bin/bash

# runs continuously, watches for file changes and compiles coffeescript into .js file(s)

DIR="$( cd "$( dirname "$0" )" && pwd )/../"

coffee --watch --compile -o $DIR/js $DIR/coffeescript/
