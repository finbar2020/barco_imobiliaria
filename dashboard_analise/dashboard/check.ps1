$j = Get-Content 'assets\analysis.json' -Raw | ConvertFrom-Json
$p = $j.projects | Where-Object { $_.folderName -eq 'app-lello-shared' }
$p.blocMetrics.perFeature | Where-Object { $_.name -in @('comfort','expired_session','registration','reset_password','authentication','code_validation','gdp') } | Select-Object name, grade, @{N='stdGrade';E={$_.standardization.grade}} | Format-Table -AutoSize
Write-Host "TOTAL SHARED grade:" $p.blocMetrics.totals.grade "stdGrade:" $p.blocMetrics.totals.standardization.grade
