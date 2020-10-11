param (
    [string]$Certificate = $(throw "-Certificate is required."),
    [string]$Executable = $(throw "-Executable is required.")
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# TODO MY FINGERPRINT - I THINK - NOT GITHUB'S
$thumbprint = "E8:C0:7A:39:2D:25:C1:57:B2:1C:CD:4E:96:A9:CC:59:76:E4:60:9E"
$passwd = $env:GITHUB_CERT_PASSWORD
$ProgramName = "GitHub CLI"

$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition

& $scriptPath\signtool.exe sign /d $ProgramName /f $Certificate /p $passwd `
    /sha1 $thumbprint /fd sha256 /tr http://timestamp.digicert.com /td sha256 /v `
    $Executable
