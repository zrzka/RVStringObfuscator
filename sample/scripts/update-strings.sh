#!/bin/bash

SCRIPT_PATH="`dirname \"$0\"`"
SCRIPT_PATH="`( cd \"$SCRIPT_PATH\" && pwd )`"

"$SCRIPT_PATH/StringObfuscator" "$SCRIPT_PATH/../StringObfuscatorSample/sample.txt" "$SCRIPT_PATH/../StringObfuscatorSample/SOStrings.h" SO_STRINGS 321 3 7
