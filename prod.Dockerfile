from ubuntu:focal

RUN apt-get update && \
apt-get -y install apt apt-utils && \
DEBIAN_FRONTEND=noninteractive apt-get -y install sudo git curl libicu-dev libncurses-dev libgmp-dev zlib1g-dev
RUN echo "Set disable_coredump false" >> /etc/sudo.conf

RUN useradd -m -G sudo -U ubuntu
RUN echo 'ubuntu ALL=NOPASSWD: ALL' >> /etc/sudoers;

USER ubuntu
WORKDIR /home/ubuntu

RUN curl -sSL https://get.haskellstack.org/ | sh

ARG SH_CONF_FILE=/home/ubuntu/.bashrc
ARG STACK_LTS=lts-15.13

RUN echo 'export PATH=$HOME/.local/bin:$PATH' >> $SH_CONF_FILE
RUN echo "alias ghc='stack ghc -- '" >> $SH_CONF_FILE
RUN echo "alias ghci='stack ghci -- '" >> $SH_CONF_FILE
RUN echo "alias stack='stack --resolver="$STACK_LTS" '" >> $SH_CONF_FILE


RUN stack ghc --resolver=$STACK_LTS -- -e '"GHC downloaded!"'

RUN git clone https://github.com/haskell/haskell-language-server /home/ubuntu/.haskell-language-server --recurse-submodules


CMD ["/bin/bash"]

