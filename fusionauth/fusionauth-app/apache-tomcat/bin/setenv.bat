@echo off
REM
REM FusionAuth environment setup. This script parses the fusionauth.properties files to set JAVA_OPTS.
REM


set FUSIONAUTH_PLUGIN_DIR=%CATALINA_HOME%\..\..\plugins
set FUSIONAUTH_CONFIG_DIR=%CATALINA_HOME%\..\..\config
set FUSIONAUTH_JAVA_DIR=%CATALINA_HOME%\..\..\java
set FUSIONAUTH_LOG_DIR=%CATALINA_HOME%\..\..\logs
set CATALINA_OUT=%FUSIONAUTH_LOG_DIR%\fusionauth-app.log
set CATALINA_OPTS=-Dfusionauth.home.directory=%CATALINA_HOME%\.. -Dfusionauth.config.directory=%FUSIONAUTH_CONFIG_DIR% -Dfusionauth.log.directory=%FUSIONAUTH_LOG_DIR% -Dfusionauth.plugin.directory=%FUSIONAUTH_PLUGIN_DIR%

set JAVA_VERSION=14.0.1
set JAVA_REVISION=7

Powershell.exe -executionpolicy ByPass -File %CATALINA_HOME%\bin\install_java.ps1

set JAVA_HOME=%FUSIONAUTH_JAVA_DIR%\jdk-%JAVA_VERSION%+%JAVA_REVISION%

set JAVA_OPTS=-Djava.awt.headless=true -Dcom.sun.org.apache.xml.internal.security.ignoreLineBreaks=true -Dnashorn.args=--no-deprecation-warning --enable-preview
for /f "delims=" %%a in ('dir /S /B /AD %CATALINA_HOME%\..\java\jdk*') do set JAVA_HOME=%%a

if not exist "%FUSIONAUTH_LOG_DIR%" (
  mkdir "%FUSIONAUTH_LOG_DIR%"
)

if not exist "%CATALINA_HOME%\logs" (
  mkdir "%CATALINA_HOME%\logs"
)

@setlocal enableextensions enabledelayedexpansion

if exist "%FUSIONAUTH_CONFIG_DIR%\fusionauth.properties" (
  for /F "eol=#" %%L in (%FUSIONAUTH_CONFIG_DIR%\fusionauth.properties) do (
    for /F "delims== tokens=1,2" %%A in ("%%L") do (
      set name=%%A
      set value=%%B
    )

    if "!name:.http-port=!" == "fusionauth-app" (
      set JAVA_OPTS=!JAVA_OPTS! -Dfusionauth.http.port=!value!
    )

    if "!name:.https-port=!" == "fusionauth-app" (
      set JAVA_OPTS=!JAVA_OPTS! -Dfusionauth.https.port=!value!
    )

    if "!name:.ajp-port=!" == "fusionauth-app" (
      set JAVA_OPTS=!JAVA_OPTS! -Dfusionauth.ajp.port=!value!
    )

    if "!name:.management-port=!" == "fusionauth-app" (
      set JAVA_OPTS=!JAVA_OPTS! -Dfusionauth.management.port=!value!
    )

    if "!name:.memory=!" == "fusionauth-app" (
      set CATALINA_OPTS=!CATALINA_OPTS! -Xmx!value! -Xms!value!
    )

    if "!name:.additional-java-args=!" == "fusionauth-app" (
      call :extractAdditionalArgs "%%L" "!name!"
    )

    if "!name:.cookie-same-site-policy=!" == "fusionauth-app" (
      if "!FUSIONAUTH_COOKIE_SAME_SITE_POLICY!" == "" (
        if not [!value!] == [] (
          set JAVA_OPTS=!JAVA_OPTS! -Dfusionauth.cookie.same.site.policy=!value!
        )
        if [!value!] == [] (
          set JAVA_OPTS=!JAVA_OPTS! -Dfusionauth.cookie.same.site.policy=Lax
        )
      )
    )
  )
)

goto :fusionauthConfigDone

:extractAdditionalArgs
set line=%1
set replacement=%2
set line=%line:~1,-1%
set replacement=%replacement:~1,-1%
set line=!line:%replacement%=!
set line=%line:~1%
set CATALINA_OPTS=!CATALINA_OPTS! %line%
goto :eof

:fusionauthConfigDone

endlocal & set JAVA_OPTS=%JAVA_OPTS% & set CATALINA_OPTS=%CATALINA_OPTS%