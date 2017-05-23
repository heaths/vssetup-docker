# Copyright (C) Microsoft Corporation. All rights reserved.
# Licensed under the MIT license. See LICENSE.txt in the project root for license information.

# Based on latest image cached by AppVeyor: https://www.appveyor.com/docs/build-environment/#image-updates
FROM microsoft/windowsservercore:10.0.14393.1198
SHELL ["powershell.exe", "-ExecutionPolicy", "Bypass", "-Command"]

# Download and register current query APIs
ARG API_VERSION
ENV API_VERSION=${API_VERSION:-"1.8.24"}
RUN $ErrorActionPreference = 'Stop' ; \
    $VerbosePreference = 'Continue' ; \
    Invoke-WebRequest -Uri "https://www.nuget.org/api/v2/package/Microsoft.VisualStudio.Setup.Configuration.Native/${env:API_VERSION}" -OutFile "${env:TEMP}\Microsoft.VisualStudio.Setup.Configuration.Native.zip" ; \
    Expand-Archive -Path "${env:TEMP}\Microsoft.VisualStudio.Setup.Configuration.Native.zip" -DestinationPath "${env:TEMP}\Microsoft.VisualStudio.Setup.Configuration.Native" ; \
    Remove-Item -Path "${env:TEMP}\Microsoft.VisualStudio.Setup.Configuration.Native.zip" ; \
    Start-Process -Wait -FilePath C:\Windows\System32\regsvr32.exe -ArgumentList '/s', "${env:TEMP}\Microsoft.VisualStudio.Setup.Configuration.Native\tools\x64\Microsoft.VisualStudio.Setup.Configuration.Native.dll" ; \
    Start-Process -Wait -FilePath C:\Windows\SysWOW64\regsvr32.exe -ArgumentList '/s', "${env:TEMP}\Microsoft.VisualStudio.Setup.Configuration.Native\tools\x86\Microsoft.VisualStudio.Setup.Configuration.Native.dll"

ENTRYPOINT ["powershell.exe", "-ExecutionPolicy", "Unrestricted"]
CMD ["-NoExit"]
