[cmdletbinding()]
param(
  [string]
  [Parameter(Mandatory = $true, Position = 0)]
  $requiredPsVersion,
  [string]
  [Parameter(Mandatory = $true, Position = 1)]
  $script,
  [string]
  [Parameter(Mandatory = $false)]
  $PowerShellPreviewPath,
  [string]
  [Parameter(Mandatory = $true)]
  $AgentOS
)

Write-Host "Required Version:", $requiredPsVersion, ", script:", $script
$windowsPowershellVersion = "5.1.14"

$script += " -ErrorAction Stop"
if($requiredPsVersion -eq $windowsPowershellVersion){
    Invoke-Command -ScriptBlock { param ($command) &"powershell.exe" -Command $command } -ArgumentList $script 
}else{
    $command = "`$PSVersionTable `
                  $script `
                  Exit"
    if($requiredPsVersion -eq "preview"){
      if ( $AgentOS -ne $IsWinEnv) { chmod 755 "$PowerShellPreviewPath/pwsh" }
      . "$PowerShellPreviewPath/pwsh" -Command $command
    }else{
      dotnet tool run pwsh -c $command
    }
}