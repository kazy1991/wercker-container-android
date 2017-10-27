FROM ubuntu:14.04
MAINTAINER kazuki-yoshida <kzk.yshd@gmail.com>

# Basic environment setup
RUN \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install gradle git-core build-essential zip curl python-pip python-software-properties apt-file lib32z1 -y && \
  apt-file update -y && \
  apt-get install software-properties-common -y && \
  apt-add-repository ppa:brightbox/ruby-ng -y && \
  dpkg --add-architecture i386 && \
  apt-get update -y && \
  apt-get install libncurses5:i386 libstdc++6:i386 zlib1g:i386 ruby2.3 ruby2.3-dev -y

# Java setup
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update -y && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Android SDK installation
RUN cd /usr/local/ && curl -L -O https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && unzip -qq sdk-tools-linux-3859397.zip -d android-sdk-linux && \
    /usr/local/android-sdk-linux/tools/bin/sdkmanager "tools" "platform-tools" "build-tools;26.0.2" "platforms;android-26" "extras;google;google_play_services" "extras;google;m2repository" "extras;android;m2repository" \
    rm -rf /usr/local/sdk-tools-linux-3859397.zip

# Add license flies
RUN mkdir -p /usr/local/android-sdk-linux/licenses && \
    echo "\n8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > /usr/local/android-sdk-linux/licenses/android-sdk-license && \
    echo "\nd975f751698a77b662f1254ddbeed3901e976f5a" > /usr/local/android-sdk-linux/licenses/intel-android-extra-license

# Environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle \
    JAVA8_HOME=/usr/lib/jvm/java-8-oracle \
    ANDROID_HOME=/usr/local/android-sdk-linux \
    GRADLE_HOME=/usr/local/gradle-3.3 \
    PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$GRADLE_HOME/bin
