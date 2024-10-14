FROM rocker/verse
MAINTAINER Vincent Toups <toups@email.unc.edu>
RUN apt update -y && apt install -y sqlite3 
ARG linux_user_pwd
RUN echo Hello World
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo "rstudio:$linux_user_pwd" | chpasswd
RUN adduser rstudio sudo
RUN R -e "install.packages('gbm');"
RUN R -e "install.packages('caret');"
RUN R -e "install.packages('e1071');"
RUN R -e "install.packages('leaps');"
