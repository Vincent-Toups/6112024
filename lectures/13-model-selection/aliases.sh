# handy aliases for working with the docker file
# and doing other stuff

source secrets.sh

alias bu='docker build . -t l12 --build-arg linux_user_pwd=$SECRET_PWD'
alias r='docker run -v `pwd`:/home/rstudio -e PASSWORD=$SECRET_PWD -it l12 sudo -H -u rstudio /bin/bash -c "cd ~/; R"'
alias rss='docker run -v `pwd`:/home/rstudio -e PASSWORD=$SECRET_PWD -p 8787:8787 -t l12'
alias b='docker run -v `pwd`:/home/rstudio -e PASSWORD=$SECRET_PWD -it l12 sudo -H -u rstudio /bin/bash -c "cd ~/; /bin/bash"'
