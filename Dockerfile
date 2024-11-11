# Use the Rocker/verse image as the base
FROM rocker/verse:latest

# Install dependencies for adding PPAs
RUN apt-get update && apt-get install -y \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

RUN apt update && apt install git 

# Add the Emacs PPA and install Emacs
RUN add-apt-repository ppa:kelleyk/emacs && \
    apt-get update && \
    apt-get install -y \
    emacs \
    git \
    sqlite3 \
    libx11-6 \
    && rm -rf /var/lib/apt/lists/*

# Set environment variable for DISPLAY
ENV DISPLAY=:0

# Verify the installations
RUN emacs --version
RUN git --version
RUN sqlite3 --version

RUN apt-get update && apt-get install -y python3 python3-pip

# Install the required Python packages
RUN pip3 install scikit-learn bokeh plotnine

RUN pip3 install scikit-learn bokeh plotnine jupyterlab

RUN R -e "install.packages(c('gbm','pROC'))"
# Install dependencies
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Jupyter Lab, Bokeh, and necessary extensions directly via pip
RUN pip3 install jupyterlab bokeh jupyter_bokeh ipywidgets

# Optional: Install additional extensions
RUN pip3 install jupyterlab_code_formatter jupyterlab-git

RUN pip3 install nltk llama_cpp_python tqdm openai gensim

# Set the default command to start Emacs
CMD ["emacs"]