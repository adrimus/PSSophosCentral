# PSSophosCentral

WIP: Experimenting with Sophos Central APIs with a PowerShell module I created.

## Getting started

[Getting Started](https://developer.sophos.com/getting-started-organization)

## TODO

- How to handle or list multi tenant
- Results for endpoint commands which have more results and need subsequent API calls

## Pester Test examples

### From the  terminal

```powershell
cd C:\github\PSSophosCentral\test\
Invoke-Pester C:\github\PSSophosCentral\test\ -TagFilter module
```

```powershell
Invoke-Pester C:\github\PSSophosCentral\test\
```

### From VS Code

You could also just dot source the script:

```powershell
PS C:\github\PSSophosCentral\test> . 'C:\github\PSSophosCentral\test\Get-PSSophosCentralAllEndpoints.Test.ps1'
```
