#!/bin/bash

#
# FusionAuth environment setup. The fusionauth.properties file
# is parsed by this script to setup additional command-line properties including memory settings.
#

# Fail on any command failure
set -e

FUSIONAUTH_PLUGIN_DIR=${CATALINA_HOME}/../../plugins
FUSIONAUTH_CONFIG_DIR=${CATALINA_HOME}/../../config
FUSIONAUTH_JAVA_DIR=${CATALINA_HOME}/../../java
FUSIONAUTH_LOG_DIR=${CATALINA_HOME}/../../logs
CATALINA_OUT=${FUSIONAUTH_LOG_DIR}/fusionauth-app.log
CATALINA_OPTS="-Dfusionauth.home.directory=$CATALINA_HOME/.. -Dfusionauth.config.directory=$FUSIONAUTH_CONFIG_DIR -Dfusionauth.log.directory=$FUSIONAUTH_LOG_DIR -Dfusionauth.plugin.directory=$FUSIONAUTH_PLUGIN_DIR"
JAVA_OPTS=" -Djava.awt.headless=true -Dcom.sun.org.apache.xml.internal.security.ignoreLineBreaks=true -Dnashorn.args=--no-deprecation-warning --enable-preview"
JAVA_OPTS=$(echo "${JAVA_OPTS}" | tr -d '\r')

CURL_OPTS="-fSL --progress-bar"
# If we are in a non interactive shell then hide the progress but show errors
if ! tty -s; then
  CURL_OPTS="-sS"
fi

if [ ! -d "${CATALINA_HOME}/logs" ]; then
  mkdir -p "${CATALINA_HOME}/logs"
fi

if [ ! -d "${FUSIONAUTH_JAVA_DIR}" ]; then
  mkdir -p "${FUSIONAUTH_JAVA_DIR}"
fi

if [ ! -d "${FUSIONAUTH_LOG_DIR}" ]; then
  mkdir -p "${FUSIONAUTH_LOG_DIR}"
fi

function downloadJava() {
  JAVA_VERSION=14.0.1+7
  BASE_URL_PATH=https://storage.googleapis.com/inversoft_products_j098230498/java/openjdk

  # Ensure both the 'current' and 'jdk-${JAVA_VERSION}' exist, this tells us Java is setup and at the correct version
  if [ ! -e "${FUSIONAUTH_JAVA_DIR}/current" ] || [ ! -d "${FUSIONAUTH_JAVA_DIR}/jdk-${JAVA_VERSION}" ]; then
    if [ "$(uname -s)" = "Darwin" ]; then
      if [ -e ~/dev/java/current14 ]; then
        # Development, just sym link to our current version of Java, because only 'current' will exist in dev, we'll always rebuild the symlink.
        cd "${FUSIONAUTH_JAVA_DIR}"
        rm -f current
        ln -s ~/dev/java/current14 current
      else
        curl ${CURL_OPTS} "${BASE_URL_PATH}/openjdk-macos-${JAVA_VERSION}.tar.gz" -o "${FUSIONAUTH_JAVA_DIR}/openjdk-macos-${JAVA_VERSION}.tar.gz"
        tar xfz "${FUSIONAUTH_JAVA_DIR}/openjdk-macos-${JAVA_VERSION}.tar.gz" -C "${FUSIONAUTH_JAVA_DIR}"
        cd "${FUSIONAUTH_JAVA_DIR}"
        rm -f current
        ln -s jdk-${JAVA_VERSION}/Contents/Home current
        rm openjdk-macos-${JAVA_VERSION}.tar.gz
      fi
    elif [ "$(uname -s)" = "Linux" ]; then
      curl ${CURL_OPTS} "${BASE_URL_PATH}/openjdk-linux-${JAVA_VERSION}.tar.gz" -o "${FUSIONAUTH_JAVA_DIR}/openjdk-linux-${JAVA_VERSION}.tar.gz"
      tar xfz "${FUSIONAUTH_JAVA_DIR}/openjdk-linux-${JAVA_VERSION}.tar.gz" -C "${FUSIONAUTH_JAVA_DIR}"
      cd "${FUSIONAUTH_JAVA_DIR}"
      rm -f current
      ln -s jdk-${JAVA_VERSION} current
      rm openjdk-linux-${JAVA_VERSION}.tar.gz
    fi
  fi
}

if [ "$FUSIONAUTH_USE_GLOBAL_JAVA" != "1" ]; then
  # Download Java if necessary
  downloadJava

  # Set JAVA_HOME
  JAVA_HOME=${FUSIONAUTH_JAVA_DIR}/current
fi

if [ -f "${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties" ]; then
  value=$(grep "^fusionauth-app.http-port" "${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties" | awk -F'=' '{ sub(/\r$/,""); print $2}')
  if [ -n "${FUSIONAUTH_HTTP_PORT}" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.http.port=$FUSIONAUTH_HTTP_PORT"
  elif [ -n "$value" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.http.port=$value"
  fi

  value=$(grep "^fusionauth-app.https-port" "${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties" | awk -F'=' '{ sub(/\r$/,""); print $2}')
  if [ -n "${FUSIONAUTH_HTTPS_PORT}" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.https.port=$FUSIONAUTH_HTTPS_PORT"
  elif [ -n "$value" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.https.port=$value"
  fi

  value=$(grep "^fusionauth-app.ajp-port" "${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties" | awk -F'=' '{ sub(/\r$/,""); print $2}')
  if [ -n "${FUSIONAUTH_AJP_PORT}" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.ajp.port=$FUSIONAUTH_AJP_PORT"
  elif [ -n "$value" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.ajp.port=$value"
  fi

  value=$(grep "^fusionauth-app.management-port" "${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties" | awk -F'=' '{ sub(/\r$/,""); print $2}')
  if [ -n "${FUSIONAUTH_MANAGEMENT_PORT}" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.management.port=$FUSIONAUTH_MANAGEMENT_PORT"
  elif [ -n "$value" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.management.port=$value"
  fi

  value=$(grep "^fusionauth-app.memory" "${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties" | awk -F'=' '{ sub(/\r$/,""); print $2}')
  if [ -n "${FUSIONAUTH_MEMORY}" ]; then
    CATALINA_OPTS="$CATALINA_OPTS -Xms$FUSIONAUTH_MEMORY -Xmx$FUSIONAUTH_MEMORY"
  elif [ -n "$value" ]; then
    CATALINA_OPTS="$CATALINA_OPTS -Xms$value -Xmx$value"
  fi

  value=$(grep "^fusionauth-app.additional-java-args" "${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties" | sed 's/^[a-zA-Z.-]*=//' | awk '{ sub(/\r$/,""); print }')
  if [ -n "${FUSIONAUTH_ADDITIONAL_JAVA_ARGS}" ]; then
    CATALINA_OPTS="$CATALINA_OPTS $FUSIONAUTH_ADDITIONAL_JAVA_ARGS"
  elif [ -n "$value" ]; then
    CATALINA_OPTS="$CATALINA_OPTS $value"
  fi

  value=$(grep "^fusionauth-app.cookie-same-site-policy" "${FUSIONAUTH_CONFIG_DIR}/fusionauth.properties" | sed 's/^[a-zA-Z.-]*=//' | awk '{ sub(/\r$/,""); print }')
  if [ -n "${FUSIONAUTH_COOKIE_SAME_SITE_POLICY}" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.cookie.same.site.policy=$FUSIONAUTH_COOKIE_SAME_SITE_POLICY"
  elif [ -n "$value" ]; then
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.cookie.same.site.policy=$value"
  else
    # Defaults to Lax
    JAVA_OPTS="$JAVA_OPTS -Dfusionauth.cookie.same.site.policy=Lax"
  fi
fi
