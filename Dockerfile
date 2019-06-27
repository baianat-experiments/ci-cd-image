FROM ubuntu:18.04

LABEL maintainer="Abdelrahman Awad"
LABEL email="code@baianat.com"
LABEL description="This image is used to build our projects on CI/CD platforms"

ENV DEBIAN_FRONTEND=noninteractive

# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Set unicode
ENV LANG=C.UTF-8

# Add CURL, git
RUN apt-get update && apt-get install -y git python3 python3-setuptools python3-pip curl

# Install Node
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

# Add Yarn to the package list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install Python, pip, git and yarn
RUN apt-get update && apt-get install -y yarn

# Install AWS and AWS EB CLI tools
RUN pip3 install --upgrade PySocks
RUN pip3 install --upgrade awscli
RUN pip3 install --upgrade awsebcli

# Add the eb script initializer
ADD scripts/eb-init.sh /eb-init.sh

CMD ["/bin/sh"]
