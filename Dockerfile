# Base
FROM docker.io/rockylinux/rockylinux:8
LABEL maintainer="Damian Troy <github@black.hole.com.au>"
RUN dnf -y update && dnf clean all

# Common
ENV PUID=1001
ENV PGID=1001
ENV TMPDIR=/var/tmp
RUN groupadd -g "${PGID}" videos && \
    useradd --no-log-init -u "${PUID}" -g videos -d /config -M videos && \
    install -d -m 0755 -o videos -g videos /config /videos
ENV TZ=Australia/Melbourne
ENV LANG=C.UTF-8
COPY test.sh /usr/local/bin/

# App
RUN yum -y install epel-release && \
    yum -y install nmap-ncat gzip jq libicu && \
    yum clean all
RUN VERSION=$(curl -s 'https://api.github.com/repos/Jackett/Jackett/releases/latest' |jq -r '.tag_name') && \
    curl -sLo /tmp/Jackett.Binaries.LinuxAMDx64.tar.gz "https://github.com/Jackett/Jackett/releases/download/${VERSION}/Jackett.Binaries.LinuxAMDx64.tar.gz" && \
    tar xzf /tmp/Jackett.Binaries.LinuxAMDx64.tar.gz -C /opt/ && \
    chown -R "${PUID}:${PGID}" /opt/Jackett && \
    rm -f /tmp/Jackett.Binaries.LinuxAMDx64.tar.gz

# Runtime
VOLUME /config /videos
EXPOSE 9117
USER videos
CMD ["/opt/Jackett/jackett","--NoUpdates","--DataFolder=/config"]
