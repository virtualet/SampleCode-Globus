ARG WINDOWS_CONTAINER_VERSION=ltsc2016
FROM mcr.microsoft.com/windows/servercore:${WINDOWS_CONTAINER_VERSION}

# Install Microsoft Build Tools
SHELL ["cmd", "/S", "/C"]

# Install Chocolatey
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Set-ExecutionPolicy Bypass -Scope Process -Force;[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls,Tls11,Tls12'; 

RUN choco install -y cmake.install --installargs '"ADD_CMAKE_TO_PATH=System"'
