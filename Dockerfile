FROM debian:buster

MAINTAINER nikita@mygento.ru

ENV DEBIAN_FRONTEND=noninteractive VAULT_VERSION=1.8.2 FIREFOX_DRIVER=v0.29.1 CHROME_DRIVER=92.0.4515.107 ALLURE=2.14.0

RUN apt-get -qq update && \
    apt-get install -qqy curl wget unzip zip gnupg git jq && \
    apt-get install -qqy php7.3-cli php7.3-mbstring php7.3-zip php7.3-curl php7.3-bcmath php7.3-xml

RUN wget -q https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip vault_${VAULT_VERSION}_linux_amd64.zip && \
    mv vault /usr/local/bin/vault && \
    chmod +x /usr/local/bin/vault && \
    rm vault_${VAULT_VERSION}_linux_amd64.zip

# Install Composer
RUN curl -L https://getcomposer.org/composer-1.phar -o /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer && \
    composer global require symfony/console && \
    composer global require guzzlehttp/guzzle && \
    rm -fR ~/.composer/cache

# Install Codecept
RUN curl -LsS http://codeception.com/codecept.phar -o /usr/local/bin/codecept && \
    chmod a+x /usr/local/bin/codecept

# Install Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
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
    curl -L https://github.com/allure-framework/allure2/releases/download/"$ALLURE"/allure_"$ALLURE"-1_all.deb -o allure.deb && \
    dpkg -i allure.deb

# install NodeJS
RUN apt-get -qq update && \
    apt-get -qqy install curl gnupg \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash \
    && apt-get -qqy install nodejs

# Install Lighthouse
RUN npm install -g lighthouse lighthouse-ci

CMD /usr/local/bin/codecept
