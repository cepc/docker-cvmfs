##
## cepc/cvmfs-cepc
## A container where CernVM-FS is up and running
##
FROM hepsw/slc-base
MAINTAINER Xianghu Zhao "zhaoxh@ihep.ac.cn"

USER root
ENV USER root
ENV HOME /root

## make sure FUSE can be enabled
RUN if [[ ! -e /dev/fuse ]]; then mknod -m 666 /dev/fuse c 10 229; fi

# install cvmfs repos
RUN rpm --rebuilddb && yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm

# Install rpms
RUN rpm --rebuilddb && yum update -y && yum install -y \
    cvmfs cvmfs-auto-setup cvmfs-config-default \
    openssh-server \
    man vim nano bash-completion\
    glibc-devel zlib-devel \
    libX11 libXext libXmu libXpm libXft libXt xorg-x11-xauth \
    mesa-libGL mesa-libGLU freeglut \
    git java-1.8.0-openjdk mysql fftw \
    ; \
    yum clean -y all

ADD etc-cvmfs-domain-ihep   /etc/cvmfs/domain.d/ihep.ac.cn.conf
ADD etc-cvmfs-keys-ihep     /etc/cvmfs/keys/ihep.ac.cn
ADD etc-cvmfs-default-local /etc/cvmfs/default.local

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh

RUN mkdir -p /cvmfs/cepc.ihep.ac.cn
RUN echo "cepc.ihep.ac.cn /cvmfs/cepc.ihep.ac.cn cvmfs defaults 0 0" >> /etc/fstab

ADD dot-bashrc       $HOME/.bashrc
ADD dot-cepcenv-conf $HOME/.cepcenv.conf

WORKDIR /root

## make the whole container seamlessly executable

ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]

## EOF
