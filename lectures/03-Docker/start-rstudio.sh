#!/bin/bash

ID=$(docker run -d -e PASSWORD=611_example -v $(pwd)../../:/home/rstudio/work -p 8787:8787 --rm -t 611-example)

echo Started docker container: $ID


