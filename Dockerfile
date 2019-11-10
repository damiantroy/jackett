# Base
FROM centos:7
LABEL maintainer="Damian Troy <github@black.hole.com.au>"
RUN yum -y update && yum clean all

# Common
VOLUME /config
ENV PUID=1001
ENV PGID=1001
RUN groupadd -g ${PGID} videos && \
    useradd --no-log-init -u ${PUID} -g videos -d /config -M videos
ENV TZ=Australia/Melbourne
COPY test.sh /usr/local/bin/

# App
VOLUME /videos
EXPOSE 9117
RUN yum -y install epel-release && \
    yum -y install nmap-ncat jq libicu && \
    yum clean all
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN VERSION=$(curl -s 'https://api.github.com/repos/Jackett/Jackett/releases/latest' |jq -r '.tag_name') && \
    curl -sLo /tmp/Jackett.Binaries.LinuxAMDx64.tar.gz "https://github.com/Jackett/Jackett/releases/download/${VERSION}/Jackett.Binaries.LinuxAMDx64.tar.gz" && \
    tar xzf /tmp/Jackett.Binaries.LinuxAMDx64.tar.gz -C /opt/ && \
    chown -R ${PUID}:${PGID} /opt/Jackett && \
    rm -f /tmp/Jackett.Binaries.LinuxAMDx64.tar.gz

# Runtime
USER videos
CMD ["/opt/Jackett/jackett","--NoUpdates","--DataFolder=/config"]

