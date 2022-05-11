# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in
# compliance with the License. You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License
# is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied. See the License for the specific language governing permissions and limitations under the
# License.
#
# Following script works with the Windows 2016 image provided by GCE.
# If running a different version of Windows/Powershell, changes may be needed.
# We are in the first phase where we need to configure PowerShell, install Chocolatey, install the OpenSSH Server.
Write-Output "Setting execution policy for PowerShell scripts...";
Set-ExecutionPolicy Bypass -Scope Process -Force;

Write-Output "Installing Chocolatey...";
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'));

Write-Output "Refreshing environment...";
RefreshEnv.cmd

Write-Output "Installing OpenSSH Server..."
choco install -y openssh -params '"/SSHServerFeature /KeyBasedAuthenticationFeature"'

if ($LastExitCode -ne 0) {
exit 1
}

Write-Output "Installing Java 8..."
choco install -y jre8

Write-Output "Installing Docker Desktop..."
# Installing Docker via powershell due to bugs with Choco install
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name DockerMsftProvider -Force
Install-Package -Name docker -ProviderName DockerMsftProvider -Force
#choco install docker-desktop --version=2.5.0.1

Write-Output "Installing Git ..."
choco install -y git

Write-Output "Installing Curl ..."
choco install -y curl

# No need to add a user if you've already configured one.
Write-Output "Adding build user..."
$username = "jenkins"
$password = ConvertTo-SecureString "P4ssword1" -AsPlainText -Force

New-LocalUser -Name $username -Password $password
Add-LocalGroupMember -Group "Administrators" -Member "$username"

# Following steps are only needed if you would like to use key-based authentication for SSH.
# Following step is needed so that new user will show up in HKLM.
Write-Output "Simulating new user login..."
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $username,$password
Start-Process cmd /c -WindowStyle Hidden -Credential $cred -ErrorAction SilentlyContinue

# You will need to insert your own public key here.
Write-Output "Creating key file and writing public key to file"
$ConfiguredPublicKey = "admin_:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8VSHBJaZzShovwu7HpYeiDV0UmSBaNYAuUxWkhE3cLYX//Ngb0l0vOP1hzIgoBwC6Zyo0VqIEwwM4F8qapKkEyFdCVMNcv/68QpM2/8LrVTUuQpaNdAHG1Zi++qQLs21b/5L7XgbTubShu9Qc8G0Lb45A8uBnrFHxjDq3mzEWh+zWEV9XSypMO6C8o1Q8QMxN6CZ4cchQ+uTmaP54YijpY3ucGyqOsHJEKgLhEL0tmwtEqXA2QdCsWtIyPoOV7RsLSkdOb5Tsvx5Cvfyzgb+QUGfnqkbv9t6ZKoYFQh9qxPSsNzI3Lz9OWGB7dRmq/gXAAwW3AGVhPVVryMil9SgN argolis cloud shell admin user"

# Fix up permissions on authorized_keys.
Set-Content -Path $env:PROGRAMDATA\ssh\administrators_authorized_keys -Value $ConfiguredPublicKey
icacls $env:PROGRAMDATA\ssh\administrators_authorized_keys /inheritance:r
icacls $env:PROGRAMDATA\ssh\administrators_authorized_keys /grant SYSTEM:`(F`)
icacls $env:PROGRAMDATA\ssh\administrators_authorized_keys /grant BUILTIN\Administrators:`(F`)
