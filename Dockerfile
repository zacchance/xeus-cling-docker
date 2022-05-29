# Base image
FROM ubuntu:20.04

# Arguments
ARG DEFAULT_PASSWD="pass"
ARG DEFAULT_USER="admin"
ARG PROXY=""

# Entrypoint
CMD ["/bin/bash"]

# Shell
SHELL ["/bin/bash", "-c"]

# Update
RUN apt-get update
RUN apt-get upgrade -y

# Add conda path
ENV PATH /opt/conda/bin:$PATH

# Install utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -yq curl wget git-all iputils-ping

# Install python3
RUN apt-get install python3 -y

# Install miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh
RUN mkdir -p /opt
RUN sh miniconda.sh -b -p /opt/conda
RUN rm miniconda.sh
RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh
RUN echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc
RUN echo "conda activate base" >> ~/.bashrc
RUN find /opt/conda -follow -type f -name '*.a' -delete
RUN find /opt/conda -follow -type f -name '*.js.map' -delete
RUN /opt/conda/bin/conda clean -afy

# Create user
RUN echo -r "$DEFAULT_USER\n$DEFAULT_PASSWD\n\n\n\n\n" | adduser "$DEFAULT_USER"

# Build conda environment
RUN conda create -n cling -y -c conda-forge jupyterlab xeus-cling