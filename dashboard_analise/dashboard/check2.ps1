$j = Get-Content 'assets\analysis.json' -Raw | ConvertFrom-Json
$p = $j.projects | Where-Object { $_.folderName -eq 'app-lello-shared' }
$p.blocMetrics.perFeature | Where-Object { $_.name -in @('comfort','reset_password') } | ForEach-Object {
  Write-Host "== $($_.name) =="
  $_.standardization | Format-List
}
