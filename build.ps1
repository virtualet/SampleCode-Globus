Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"
$PSDefaultParameterValues['*:ErrorAction'] = 'Stop'

function ThrowOnNativeFailure {
    if (-not $?) {
        throw 'Native Failure'
    }
}

Function New-BuildFolder {
    param (
        $ParentFolder
    )

    $RandomName = "build-$([convert]::tostring((get-random 65535),16).padleft(4,'0'))"
    $NewFolder = (Join-Path -Path "$ParentFolder" -ChildPath "$RandomName")

    New-Item -ItemType Directory -Path "$NewFolder"
}

$SourceFolder = (Resolve-Path ".").Path
Write-Host "SourceFolder = $SourceFolder"

$BuildFolder = New-BuildFolder $SourceFolder
Write-Host "BuildFolder = $BuildFolder"

$env:CC = (Get-Command "clang").Definition
Write-Host "CC = $env:CC"

$env:CXX = (Get-Command "clang++").Definition
Write-Host "CXX = $env:CXX"

cmake -S "$SourceFolder" `
    -B "$BuildFolder" `
    -G "Ninja Multi-Config"
ThrowOnNativeFailure

foreach ($BuildType in "Debug", "Release", "RelWithDebInfo") {
    cmake --build $BuildFolder --config $BuildType
    ThrowOnNativeFailure
    
    Invoke-Expression "$BuildFolder\$BuildType\Hello.exe"
    ThrowOnNativeFailure
}
