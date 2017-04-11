FROM ubuntu:14.04
MAINTAINER kazuki-yoshida <kzk.yshd@gmail.com>

# Basic environment setup
RUN \
  apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install git-core build-essential zip curl python-pip python-software-properties apt-file lib32z1 -y && \
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
RUN cd /usr/local/ && curl -L -O https://dl.google.com/android/repository/tools_r25.2.3-linux.zip && unzip -qq tools_r25.2.3-linux.zip -d android-sdk-linux && \
    echo y | /usr/local/android-sdk-linux/tools/android update sdk --no-ui --force --all --filter "tools" && \
    echo y | /usr/local/android-sdk-linux/tools/android update sdk --no-ui --force --all --filter "platform-tools" && \
    echo y | /usr/local/android-sdk-linux/tools/android update sdk --no-ui --force --all --filter "build-tools-25.0.2,android-25" && \
    echo y | /usr/local/android-sdk-linux/tools/android update sdk --no-ui --force --all --filter "extra-google-google_play_services" && \
    echo y | /usr/local/android-sdk-linux/tools/android update sdk --no-ui --force --all --filter "extra-google-m2repository" && \
    echo y | /usr/local/android-sdk-linux/tools/android update sdk --no-ui --force --all --filter "extra-android-m2repository" && \
    echo y | /usr/local/android-sdk-linux/tools/android update sdk --no-ui --force --all --filter "addon-google_apis-google-24" && \
    rm -rf /usr/local/tools_r25.2.3-linux.zip

# Add license flies
RUN mkdir -p /usr/local/android-sdk-linux/licenses && \
    echo "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > /usr/local/android-sdk-linux/licenses/android-sdk-license && \
    echo "\nd975f751698a77b662f1254ddbeed3901e976f5a" > /usr/local/android-sdk-linux/licenses/intel-android-extra-license

# Install Gradle
RUN cd /usr/local/ && \
    curl -L -O https://services.gradle.org/distributions/gradle-3.3-all.zip && \
    unzip -qq -o gradle-3.3-all.zip && \
    rm -rf   /usr/local/gradle-3.3-all.zip

# Environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle \
    JAVA8_HOME=/usr/lib/jvm/java-8-oracle \
    ANDROID_HOME=/usr/local/android-sdk-linux \
    GRADLE_HOME=/usr/local/gradle-3.3 \
    PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$GRADLE_HOME/bin
