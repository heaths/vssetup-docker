[CmdletBinding()]
param ()

Write-Verbose 'Fetching channel'
$channel = Invoke-RestMethod 'https://aka.ms/vs/15/release/channel'

Write-Verbose 'Fetching manifest'
$manifest_url = $channel.channelItems `
    | Where-Object { $_.id -eq 'Microsoft.VisualStudio.Manifests.VisualStudio' } `
    | ForEach-Object { $_.payloads[0].url }
$manifest = Invoke-RestMethod $manifest_url

$manifest.packages `
    | Where-Object { $_.id -eq 'Microsoft.VisualStudio.Setup.Configuration' } `
    | Select-Object @{l='Version'; e={$_.version}}, @{l='Url'; e={$_.payloads[0].url}}, @{l='Sha256'; e={$_.payloads[0].sha256}}
