$JAVA_PATH = "$Env:FUSIONAUTH_JAVA_DIR\jdk-${Env:JAVA_VERSION}+${Env:JAVA_REVISION}"

# Check and install java if it is missing
if (!(Test-Path $Env:FUSIONAUTH_JAVA_DIR) -or !(Test-Path $JAVA_PATH))
{
    if (!(Test-Path $Env:FUSIONAUTH_JAVA_DIR))
    {
        New-Item -ItemType Directory -Path "$Env:FUSIONAUTH_JAVA_DIR" -Force
    }
    # Invoke-WebRequest is WAY too slow, use the web client
    $webClient = new-Object System.Net.WebClient
    $webClient.DownloadFile("https://storage.googleapis.com/inversoft_products_j098230498/java/openjdk/openjdk-windows-${Env:JAVA_VERSION}+${Env:JAVA_REVISION}.zip", "$Env:FUSIONAUTH_JAVA_DIR\openjdk-windows-${Env:JAVA_VERSION}+${Env:JAVA_REVISION}.zip")
    Expand-Archive -Path "$Env:FUSIONAUTH_JAVA_DIR\openjdk-windows-${Env:JAVA_VERSION}+${Env:JAVA_REVISION}.zip" -DestinationPath $Env:FUSIONAUTH_JAVA_DIR
    Remove-Item "$Env:FUSIONAUTH_JAVA_DIR\openjdk-windows-${Env:JAVA_VERSION}+${Env:JAVA_REVISION}.zip"
}
