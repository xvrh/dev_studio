#TODO(xha):
# - try to make it work on alpine
# - create a user to run flutter

# Test it with:
# (from the repository root): docker build -f tools/dev_studio/Dockerfile -t dev_studio .
FROM debian:buster

RUN  apt-get update \
     && apt-get install -y wget gnupg ca-certificates procps libxss1 \
     && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
     && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
     && apt-get update \
     # We install Chrome to get all the OS level dependencies, but Chrome itself
     # is not actually used as it's packaged in the node puppeteer library.
     # Alternatively, we could could include the entire dep list ourselves
     # (https://github.com/puppeteer/puppeteer/blob/master/docs/troubleshooting.md#chrome-headless-doesnt-launch-on-unix)
     # but that seems too easy to get out of date.
     && apt-get install -y google-chrome-stable curl unzip sed git bash xz-utils libglvnd0 ssh xauth x11-xserver-utils libpulse0 libxcomposite1 libgl1-mesa-glx sudo \
     && rm -rf /var/lib/{apt,dpkg,cache,log} \
     && wget --quiet https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/sbin/wait-for-it.sh \
     && chmod +x /usr/sbin/wait-for-it.sh

RUN git clone https://github.com/flutter/flutter.git && \
    (cd flutter && git checkout '3.16.2') # Injected automatically by project_tools
ENV PATH="/flutter/bin:${PATH}"
RUN flutter doctor

COPY packages /packages
COPY tools/dev_studio /tools/dev_studio

WORKDIR /tools/dev_studio
RUN flutter pub get
RUN dart bin/download_chromium.dart
RUN dart compile exe bin/lambda.dart -o bin/lambda

ENTRYPOINT [ "bin/lambda" ]
CMD [ "app.handler" ]
