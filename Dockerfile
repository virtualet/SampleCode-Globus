ARG WINDOWS_CONTAINER_VERSION=ltsc2016
FROM mcr.microsoft.com/windows/servercore:${WINDOWS_CONTAINER_VERSION}

# Install Microsoft Build Tools
SHELL ["cmd", "/S", "/C"]
RUN curl -SL --output vs_buildtools.exe https://aka.ms/vs/17/release/vs_buildtools.exe && (start /w vs_buildtools.exe --wait --norestart --nocache --add "Microsoft.VisualStudio.Workload.VCTools" --add "Microsoft.VisualStudio.Component.VC.Tools.x86.x64" --add "Microsoft.VisualStudio.Component.VC.ATLMFC" --add "Microsoft.VisualStudio.Component.Windows10SDK.20348" || IF "%ERRORLEVEL%"=="3010" EXIT 0) && del /q vs_buildtools.exe

# Install Chocolatey
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Set-ExecutionPolicy Bypass -Scope Process -Force;[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]'Tls,Tls11,Tls12'; iex ((New-Object System.Net.WebClient).DownloadString('"https://chocolatey.org/install.ps1"'));

# Install build tools:
RUN choco install ninja -y
RUN choco install cmake.install --installargs '"ADD_CMAKE_TO_PATH=System"' -y
RUN choco install llvm -y

