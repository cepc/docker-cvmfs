##
## cepc/cvmfs
## A container where CernVM-FS is up and running
##
FROM hepsw/slc-base

USER root
ENV USER root
ENV HOME /root

# install rpms
RUN set -ex; \
    rpm --rebuilddb; \
    yum update -y; \
    yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm; \
    yum update -y; \
    yum install -y \
    cvmfs cvmfs-config-default fuse \
    openssh-server \
    man wget vim nano bash-completion \
    glibc-devel zlib-devel openssl-devel libxml2-devel fftw-devel python-devel \
    mysql-devel sqlite-devel \
    libX11-devel libXpm-devel libXt-devel libXft-devel libXext-devel libXmu-devel xorg-x11-xauth \
    mesa-libGL-devel mesa-libGLU-devel freeglut-devel \
    git subversion java-1.8.0-openjdk-devel \
    ; \
    yum reinstall -y cracklib-dicts; \
    yum clean -y all; \
    rm -rf /var/cache/*

COPY etc-cvmfs-domain-ihep   /etc/cvmfs/domain.d/ihep.ac.cn.conf
COPY etc-cvmfs-keys-ihep     /etc/cvmfs/keys/ihep.ac.cn
COPY etc-cvmfs-default-local /etc/cvmfs/default.local

RUN mkdir -p /cvmfs/cepc.ihep.ac.cn
RUN echo "cepc.ihep.ac.cn /cvmfs/cepc.ihep.ac.cn cvmfs defaults 0 0" >> /etc/fstab

COPY dot-bash_profile $HOME/.bash_profile
COPY dot-bashrc       $HOME/.bashrc
COPY dot-cepcenv-conf $HOME/.cepcenv.conf

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

## make sure FUSE can be enabled
#RUN if [[ ! -e /dev/fuse ]]; then mknod -m 666 /dev/fuse c 10 229; fi; chmod a+rw /dev/fuse

WORKDIR /root

## make the whole container seamlessly executable
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]

## EOF
