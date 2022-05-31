function Get-TeamsUserConfiguration {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$false)]
        [String]$jsonfile = $env:AppData + '\Microsoft\Teams\desktop-config.json',
        [String]$User = $env:USERDOMAIN + '\' + $env:USERNAME
    )
    
    Write-Verbose ($jsonfile)
    Write-Verbose ($User)

    if (Test-Path $jsonfile) {
        $json = Get-Content $jsonfile | ConvertFrom-Json
        $json.appPreferenceSettings | Out-String
    }
    else {
        Write-Error ("file does not exist: {0}", $jsonfile)
    }
}