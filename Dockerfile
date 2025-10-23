# Here we choose our base image
# In this case, we're using Debian 12 (Bookworm) and the slim version, which removes some non-essential components
FROM debian:bookworm-slim

# Here we want to make sure we have all the basic necessities for building and running our analyses
RUN apt-get update && apt-get install -y \
       build-essential curl git unzip make cmake libssl-dev \
       zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
       wget llvm libncurses5-dev libncursesw5-dev xz-utils \
       tk-dev apt-transport-https ca-certificates gnupg


# Now that we have our basic necessities, we want to start installing all the various tools we'll use
# Some we can install using apt (the package manager), others we will build from their source code

# First, let's install R
RUN apt-get install -y r-base r-base-dev

# Next, let's install Python
# RUN wget https://www.python.org/ftp/python/3.13.2/Python-3.13.2.tgz
# RUN tar -xvf Python-3.13.2.tgz
# RUN cd Python-3.13.2 && ./configure --enable-optimizations --with-ensurepip=install
# RUN cd Python-3.13.2 && make -j $(nproc)
# RUN cd Python-3.13.2 && make altinstall
# Python can now be run using `python3.13` and `pip3.13`

# Finally, let's install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Now that we have our languages installed, we can start installing the packages we need for them
RUN R -e "install.packages('remotes')"
RUN R -e "remotes::install_version('OpenMx', version = '2.21.11')"
RUN R -e "install.packages(c('data.table', 'dplyr', 'mgcv', 'doParallel', 'foreach', 'MBESS', 'corpcor', 'purrr', 'table1', 'psych', 'labelled', 'tidyverse', 'r.utils', 'ggplot2', 'compiler'))"
# RUN pip3.13 install numpy pandas matplotlib
RUN curl https://raw.githubusercontent.com/GMELab/lmutils.r/refs/heads/master/install.sh | sh

# Now that we have our languages and packages installed, we can start installing the other tools we need

# Install PLINK
RUN curl -O https://s3.amazonaws.com/plink1-assets/plink_linux_x86_64_20241022.zip
RUN unzip plink_linux_x86_64_20241022.zip
RUN mv plink /usr/local/bin
RUN rm plink_linux_x86_64_20241022.zip
RUN rm -rf plink_linux_x86_64_20241022

# Install gsutil
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && apt-get update -y && apt-get install google-cloud-cli -y
