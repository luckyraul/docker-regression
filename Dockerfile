FROM debian:buster

MAINTAINER nikita@mygento.ru

ENV DEBIAN_FRONTEND=noninteractive FIREFOX_DRIVER=v0.24.0 CHROME_DRIVER=76.0.3809.68 ALLURE=2.12.1

RUN apt-get -qq update && \
    apt-get install -qqy curl wget unzip zip gnupg git jq && \
    apt-get install -qqy php7.3-cli php7.3-mbstring php7.3-zip php7.3-curl php7.3-bcmath php7.3-xml

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
RUN wget -N https://chromedriver.storage.googleapis.com/"$CHROME_DRIVER"/chromedriver_linux64.zip -P ~/ && \
    unzip ~/chromedriver_linux64.zip -d ~/  && \
    rm ~/chromedriver_linux64.zip  && \
    mv -f ~/chromedriver /usr/local/share/ && \
    chmod +x /usr/local/share/chromedriver && \
    rm -f /usr/local/bin/chromedriver && \
    ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver

# Install Firefox
RUN apt-get -qq update && \
    apt-get -qy install firefox-esr

# Install Firefox Driver
RUN wget -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/"$FIREFOX_DRIVER"/geckodriver-"$FIREFOX_DRIVER"-linux64.tar.gz && \
    tar -zxf /tmp/geckodriver.tar.gz -C /usr/local/bin && \
    rm /tmp/geckodriver.tar.gz && \
    chmod u+x /usr/local/bin/geckodriver

# Install Allure 2
RUN apt-get -qq update && \
    apt-get install -qqy default-jre && \
    mkdir -p /opt/allure && \
    curl -fsSL -o allure2.zip https://dl.bintray.com/qameta/maven/io/qameta/allure/allure-commandline/"$ALLURE"/allure-commandline-"$ALLURE".zip && \
    unzip -q allure2.zip -d /opt/allure && \
    rm allure2.zip && \
    chmod a+x /opt/allure/allure-"$ALLURE"/bin/allure && \
    ln -s /opt/allure/allure-"$ALLURE"/bin/allure /usr/bin/allure

# install NodeJS
RUN apt-get -qq update && \
    apt-get -qqy install curl gnupg \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash \
    && apt-get -qqy install nodejs

# Install Lighthouse
RUN npm install -g lighthouse lighthouse-ci

CMD /usr/local/bin/codecept
