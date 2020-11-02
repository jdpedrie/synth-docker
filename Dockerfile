FROM ubuntu:latest

RUN apt-get update && apt-get install -y curl gnupg && \
    curl https://bazel.build/bazel-release.pub.gpg | apt-key add -

RUN echo "deb [arch=amd64] https://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list
RUN apt-get update
RUN apt-get install -y python3 bazel-3.3.0 git python3-pip zip

RUN mkdir synthtool && git clone https://github.com/googleapis/synthtool && \
    cd synthtool && \
    pip3 install -r requirements.txt

RUN echo '#!/bin/bash\nbazel-3.3.0' > /usr/bin/bazel && \
    chmod 0777 /usr/bin/bazel && chmod +x /usr/bin/bazel

RUN bazel

WORKDIR /share

CMD export SYNTHDIR=/share && \
    export LC_ALL=C.UTF-8 && \
    export LANG=C.UTF-8 && \
    export PYTHONPATH=/synthtool && \
    echo $SYNTHDIR && \
    cd $SYNTHDIR && \
    python3 -m synthtool
