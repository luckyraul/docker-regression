FROM debian:stretch

MAINTAINER nikita@mygento.ru

ENV DEBIAN_FRONTEND=noninteractive DRIVER_VERSION=2.40 ALLURE_VERSION=2.6.0

RUN apt-get -qq update && \
    apt-get install -qqy curl wget unzip gnupg && \
    apt-get install -qqy php7.0-cli php7.0-mbstring php7.0-zip php7.0-curl php7.0-bcmath php7.0-xml

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    chmod a+x /usr/local/bin/composer

# Install Codecept
RUN curl -LsS http://codeception.com/codecept.phar -o /usr/local/bin/codecept && \
    chmod a+x /usr/local/bin/codecept

# Install Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get -qq update && \
    apt-get install -qqy google-chrome-stable

# Install Chrome Driver
RUN wget -N https://chromedriver.storage.googleapis.com/"$DRIVER_VERSION"/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/  && \
    rm ~/chromedriver_linux64.zip  && \
    mv -f ~/chromedriver /usr/local/share/ && \
    chmod +x /usr/local/share/chromedriver && \
    rm -f /usr/local/bin/chromedriver && \
    ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver

# Install Allure 2
RUN apt-get -qq update && \
    apt-get install -qqy default-jre && \
    mkdir -p /opt/allure && \
    curl -fsSL -o allure2.zip https://dl.bintray.com/qameta/generic/io/qameta/allure/allure/"$ALLURE_VERSION"/allure-"$ALLURE_VERSION".zip && \
    unzip -q allure2.zip -d /opt/allure && \
    rm allure2.zip && \
    chmod a+x /opt/allure/allure-"$ALLURE_VERSION"/bin/allure && \
    ln -s /opt/allure/allure-"$ALLURE_VERSION"/bin/allure /usr/bin/allure

CMD /usr/local/bin/codecept
