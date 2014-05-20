---
layout: post
title: "Deploying a static site with MsDeploy using TFS Team Build"
date: 2014-05-20 14:04:00 +0100
comments: true
categories: continuous-delivery
---

**TODO**

* Install web deploy
* Add DWORD key named WindowsAuthenticationEnabled, with a value of 1 to HKLM\SOFTWARE\Microsoft\WebManagement\Server (This lets NTLM work properly - otherwise you'll get 401 errors and messages in event log about password being null)
* Grant access to the site for the build service account
* Add a powershell script into your source
* Add a build definition triggered on each check in
* Add the powershell script to the build definition as a post build script

Assumes of course you have a SLN file with a web site project in it which contains your static site.

This will use windows auth to automatically publish using the service account which your build service is running as.

``` powershell
$msDeployPath = "C:\Program Files\IIS\Microsoft Web Deploy V3\msdeploy.exe"
$sourceFiles = "..\bin\_PublishedWebsites\html"
$targetIISSite = "yoursite"
$targetWebDeployUrl = "https://yourserver:8172/msdeploy.axd?site="

if(!(Test-Path -Path $msDeployPath))
{
    throw "Could not find msdeploy - aborted"
    break
}

$sourceDir = Resolve-Path($sourceFiles)
$destUrl = $targetWebDeployUrl + $targetIISSite

$arguments = [string[]]@(
    "-verb:sync",
    "-source:contentPath='$sourceDir'",
    "-dest:contentPath='$targetIISSite',computername='$destUrl',AuthType='ntlm'",
    "-allowUntrusted:true"
    )

Start-Process $msDeployPath -ArgumentList $arguments -NoNewWindow -Wait
```
