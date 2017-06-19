FROM phusion/baseimage

ENV JAVA8_HOME=/opt/jdk1.8.0_65 \
  ANDROID_HOME=/opt/android-sdk \
  PATH="$PATH:/opt/jdk1.8.0_65/bin:/opt/android-sdk/tools:/opt/android-sdk/platform-tools"

RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends wget lib32stdc++6 libqt5widgets5 lib32z1 unzip
RUN apt-get install -y awscli

###################
# JDK8
###################
RUN cd /opt
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O jdk8.tar.gz http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
RUN tar xzf jdk8.tar.gz
RUN rm jdk8.tar.gz

##################
# Android licenses
##################
RUN mkdir /opt/android-sdk/
RUN mkdir /opt/android-sdk/licenses/
RUN echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > /opt/android-sdk/licenses/android-sdk-license
RUN echo "84831b9409646a918e30573bab4c9c91346d8abd" > /opt/android-sdk/licenses/android-sdk-preview-license
RUN echo "d975f751698a77b662f1254ddbeed3901e976f5a" > /opt/android-sdk/licenses/intel-android-extra-license

###################
# Android SDK
###################
RUN wget -O android-sdk.zip https://dl.google.com/android/repository/tools_r25.2.3-linux.zip
RUN unzip -a android-sdk.zip
RUN rm android-sdk.zip
RUN mv /tools /opt/android-sdk/tools
RUN echo 'y' | android update sdk --no-ui -a --filter platform-tools,build-tools-25.0.2,android-25,extra-android-support,extra-google-support,extra-google-google_play_services,extra-google-m2repository,extra-android-m2repository --force
RUN rm -rf /opt/android-sdk/add-ons
RUN rm /opt/jdk1.8.0_65/src.zip
RUN rm /opt/jdk1.8.0_65/javafx-src.zip

##################
# Speeding up android builds
# Gradle will pick these properties when running
##################
RUN mkdir ~/.gradle
RUN echo "org.gradle.daemon=true" >> ~/.gradle/gradle.properties
RUN echo "org.gradle.jvmargs=-Xmx4096m -XX:MaxPermSize=512m -XX:+HeapDumpOnOutOfMemoryError -Dfile.encoding=UTF-8" >> ~/.gradle/gradle.properties
RUN echo "org.gradle.parallel=true" >> ~/.gradle/gradle.properties
RUN echo "org.gradle.configureondemand=true" >> ~/.gradle/gradle.properties
RUN echo "android.builder.sdkDownload=true" >> ~/.gradle/gradle.properties
RUN rm -rf /var/lib/apt/lists/*
