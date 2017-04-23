#!/bin/bash

(
    echo "POV_SOURCES = " $(find . -name '*.pov' | sed 's!^./!!');
) > include.mak


