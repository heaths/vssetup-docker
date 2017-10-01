# Copyright (C) Microsoft Corporation. All rights reserved.
# Licensed under the MIT license. See LICENSE.txt in the project root for license information.

# Based on latest image cached by AppVeyor: https://www.appveyor.com/docs/build-environment/#image-updates
# FROM microsoft/windowsservercore:10.0.14393.1593
FROM microsoft/windowsservercore@sha256:c281f2c09c9446f1896806933013a350f19db8f5a009e633ebd9701c470de35b
SHELL ["powershell.exe", "-ExecutionPolicy", "Bypass", "-Command"]

ENV INSTALLER_VERSION=1.11.2331.64267 \
    INSTALLER_URI=https://download.visualstudio.microsoft.com/download/pr/10984294/d68d54e233c956ff79799fdf63753c54/Microsoft.VisualStudio.Setup.Configuration.msi \
    INSTALLER_HASH=D4DDE4522003778F57F8C0311DEC6C7D037F7CC17168D7A3884D526509B93F99

# Download and register query API version 1.11.2331.64267
RUN $ErrorActionPreference = 'Stop' ; \
    $VerbosePreference = 'Continue' ; \
    New-Item C:\TEMP -ItemType Directory -ea SilentlyContinue; \
    Invoke-WebRequest -Uri $env:INSTALLER_URI -OutFile C:\TEMP\Microsoft.VisualStudio.Setup.Configuration.msi; \
    if ((Get-FileHash -Path C:\TEMP\Microsoft.VisualStudio.Setup.Configuration.msi -Algorithm SHA256).Hash -ne $env:INSTALLER_HASH) { throw 'Download hash does not match' }; \
    Start-Process -Wait -PassThru -FilePath C:\Windows\System32\msiexec.exe -ArgumentList '/i C:\TEMP\Microsoft.VisualStudio.Setup.Configuration.msi /qn /l*vx C:\TEMP\Microsoft.VisualStudio.Setup.Configuration.log'

ENTRYPOINT ["powershell.exe", "-ExecutionPolicy", "Unrestricted"]
CMD ["-NoExit"]
