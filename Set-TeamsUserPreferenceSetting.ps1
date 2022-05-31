function Get-TeamsUserPreferenceSetting {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True)]
        [ValidateSet(
            'openAtLogin',
            'openAsHidden',
            'runningOnClose',
            'disableGpu',
            'registerAsIMProvider',
            'enableMediaLoggingPreferenceKey'
            )
        ]
        [String]$PreferenceSetting,
        
        [Parameter(Mandatory=$True)]
        [ValidateSet(
            'True',
            'False'
            )
        ]
        [String]$PreferenceValue,

        [Parameter(Mandatory=$false)]
        [String]$jsonfile = $(Join-Path $env:AppData 'Microsoft\Teams\desktop-config.json'),
        [Parameter(Mandatory=$false)]
        [String]$User = $(Join-Path $env:USERDOMAIN $env:USERNAME),
        [Parameter(Mandatory=$false)]
        [ValidationSet(
            'True',
            'False'
            )
        ]
        [String]$TeamsReset = $false
    )
    
    Write-Verbose ($jsonfile)
    Write-Verbose ($User)

    if (Test-Path $jsonfile) {
        # Terminate running process for user
        $Process = Get-Process -Name 'Teams' -IncludeUserName -ErrorAction SilentlyContinue |
            Where-Object UserName -eq $User
        if ($Process -and $TeamsReset -eq $True) {
            $Killed = Stop-Process -Name $($Process.Name) -Force -PassThru
        }

        $json = Get-Content $jsonfile | ConvertFrom-Json
        Write-Verbose ($json.appPreferenceSettings | Out-String)
    
        $json.appPreferenceSettings.$PreferenceSetting = $PreferenceValue
        $json | ConvertTo-Json | Out-File $jsonfile -Encoding ASCII
        Write-Verbose ("File has been modified.")
        if ($Killed) {
            & $(Join-Path $env:LOCALAPPDATA 'Microsoft\Teams\Update.exe') --processStart "Teams.exe"
        }
    }
    else {
        Write-Error ("file does not exist: {0}", $jsonfile)
    }
}
