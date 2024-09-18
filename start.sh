#!/bin/bash

docker build . -t 6112024 

# Check if the DISPLAY variable is set
if [ -z "$DISPLAY" ]; then
  echo "Error: DISPLAY environment variable is not set."
  exit 1
fi

# Get the current directory
CURRENT_DIR=$(pwd)

# Run the Docker container
docker run -it --rm \
       -p 8788:8787\
       -e DISPLAY=$DISPLAY \
       -v $HOME/.ssh:/home/rstudio/.ssh\
       -v $HOME/.gitconfig:/home/rstudio/.gitconfig\
       -v /tmp/.X11-unix:/tmp/.X11-unix \
       -v "$CURRENT_DIR":/home/rstudio/work \
       -v $(readlink -f ../bios611/):/home/rstudio/old_work\
       --workdir /home/rstudio/work\
       -u rstudio \
       6112024 \
       emacs --load /home/rstudio/work/init.el
