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
RUN R -e "install.packages('MLmetrics');"
RUN R -e "install.packages('glmnet');"
RUN apt update -y && apt install -y python3-pip
RUN pip3 install jupyter jupyterlab
