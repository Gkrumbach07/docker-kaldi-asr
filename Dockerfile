FROM registry.access.redhat.com/ubi8/ubi:8.1

ARG MAKE_JOBS=1

RUN curl https://raw.githubusercontent.com/dvershinin/apt-get-centos/master/apt-get.sh -o /usr/local/bin/apt-get && chmod 0755 /usr/local/bin/apt-get

RUN apt-get update && apt-get install --no-install-recommends -y  \
    autoconf \
    automake \
    bzip2 \
    g++ \
    git \
    libatlas3-base \
    libtool-bin \
    make \
    patch \
    python2.7 \
    python3 \
    python-pip \
    subversion \
    unzip \
    sox \
    gfortran \
    wget \
    zlib1g-dev && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove -y

RUN mkdir -p /opt/kaldi && \
    git clone https://github.com/kaldi-asr/kaldi /opt/kaldi && \
    cd /opt/kaldi/tools/extras && \
    ./install_mkl.sh && \
    cd /opt/kaldi/tools && \
    make -j${MAKE_JOBS} && \
    ./install_portaudio.sh && \
    cd /opt/kaldi/src && \
    ./configure --shared && \
    sed -i '/-g # -O0 -DKALDI_PARANOID/c\-O3 -DNDEBUG' kaldi.mk && \
    make -j${MAKE_JOBS} depend && \
    make -j${MAKE_JOBS} checkversion && \
    make -j${MAKE_JOBS} kaldi.mk && \
    make -j${MAKE_JOBS} mklibdir && \
    make -j${MAKE_JOBS} \
	base \
	decoder \
	fstext \
	nnet3 \
	online2 \
	util && \
    cd /opt/kaldi && git log -n1 > current-git-commit.txt && \
    rm -rf /opt/kaldi/.git && \
    rm -rf /opt/kaldi/egs/ /opt/kaldi/windows/ /opt/kaldi/misc/ && \
    find /opt/kaldi/src/ \
	 -type f \
	 -not -name '*.h' \
	 -not -name '*.so' \
	 -delete && \
    find /opt/kaldi/tools/ \
	 -type f \
	 -not -name '*.h' \
	 -not -name '*.so' \
	 -not -name '*.so*' \
	 -delete
