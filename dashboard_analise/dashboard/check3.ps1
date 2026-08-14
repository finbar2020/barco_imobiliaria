$j = Get-Content 'assets\analysis.json' -Raw | ConvertFrom-Json
$j.projects | Select-Object folderName, @{N='grade';E={$_.blocMetrics.totals.grade}}, @{N='std';E={$_.blocMetrics.totals.standardization.grade}} | Format-Table -AutoSize
Write-Host "--- shared_features todas as features ---"
$p = $j.projects | Where-Object { $_.folderName -eq 'app-lello-shared' }
$p.blocMetrics.perFeature | Sort-Object grade | Select-Object name, grade, @{N='std';E={$_.standardization.grade}} | Format-Table -AutoSize
