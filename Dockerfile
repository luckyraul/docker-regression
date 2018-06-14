FROM debian:stretch

MAINTAINER nikita@mygento.ru

ENV DEBIAN_FRONTEND=noninteractive DRIVER_VERSION=2.40

RUN apt-get -qq update && \
    apt-get install -qqy curl wget unzip gnupg php7.0-cli

RUN curl -LsS http://codeception.com/codecept.phar -o /usr/local/bin/codecept && \
    chmod a+x /usr/local/bin/codecept && \
    wget -N https://chromedriver.storage.googleapis.com/"$DRIVER_VERSION"/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/  && \
    rm ~/chromedriver_linux64.zip  && \
    mv -f ~/chromedriver /usr/local/share/ && \
    chmod +x /usr/local/share/chromedriver && \
    rm -f /usr/local/bin/chromedriver && \
    ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver && \
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
    apt-get -qq update && \
    apt-get install -qqy google-chrome-stable

CMD /usr/local/bin/codecept
