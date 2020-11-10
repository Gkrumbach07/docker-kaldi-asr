#FROM registry.access.redhat.com/ubi8/ubi:8.1
FROM centos:7

ENV CPU_CORE 4

RUN yum update -y 
RUN yum groupinstall -y "Development Tools" "System Tools"
RUN  yum install -y \
    git bzip2 wget subversion \
    gcc-c++ make automake autoconf zlib-devel python3 \
    python27 sox gcc-gfortran

WORKDIR /usr/local/
# Use the newest kaldi version
RUN git clone https://github.com/kaldi-asr/kaldi.git


WORKDIR /usr/local/kaldi/tools

RUN extras/install_mkl.sh
RUN extras/check_dependencies.sh
# RUN yum groupinstall -y "System Tools"
#RUN make -j $CPU_CORE
RUN make CXX=g++-4.8

#    libatlas-dev libatlas-base-dev

WORKDIR /usr/local/kaldi/src
RUN ./configure && make depend -j $CPU_CORE && make -j $CPU_CORE
