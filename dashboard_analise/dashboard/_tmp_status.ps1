$j = Get-Content 'assets/analysis.json' -Raw | ConvertFrom-Json
$j.projects | ForEach-Object {
  [PSCustomObject]@{
    name = $_.name
    folder = $_.folderName
    grade = $_.blocMetrics.totals.grade
    std = $_.blocMetrics.totals.standardization.grade
    absImpl = $_.blocMetrics.totals.absImplPairs
    noEq = $_.blocMetrics.totals.filesNoEquatable
    nonConst = $_.blocMetrics.totals.standardization.nonConstBaseStates
    blocs = $_.blocMetrics.totals.blocs
  }
} | Sort-Object {[int]$_.grade}, {[int]$_.std} | Format-Table -AutoSize

Write-Host "`n--- shared per feature (se grade/std < 100) ---"
$shared = $j.projects | Where-Object { $_.name -eq 'shared_features' }
$shared.blocMetrics.perFeature |
  Where-Object { $_.grade -lt 100 -or $_.standardization.grade -lt 100 } |
  Select-Object name, blocs, absImplPairs, filesNoEquatable, grade, @{N='std';E={$_.standardization.grade}} |
  Format-Table -AutoSize

Write-Host "`n--- sindico per feature (se grade/std < 100 ou pendencias) ---"
$sindico = $j.projects | Where-Object { $_.name -eq 'lello' }
$sindico.blocMetrics.perFeature |
  Where-Object { $_.grade -lt 100 -or $_.standardization.grade -lt 100 -or $_.absImplPairs -gt 0 -or $_.filesNoEquatable -gt 0 } |
  Select-Object name, blocs, absImplPairs, filesNoEquatable, grade, @{N='std';E={$_.standardization.grade}} |
  Format-Table -AutoSize

Write-Host "`n--- morar filesNoEquatable ---"
$morar = $j.projects | Where-Object { $_.name -eq 'morar' }
Write-Host ("grade={0} std={1} noEq={2}" -f $morar.blocMetrics.totals.grade, $morar.blocMetrics.totals.standardization.grade, $morar.blocMetrics.totals.filesNoEquatable)
$morar.blocMetrics.perFeature |
  Where-Object { $_.filesNoEquatable -gt 0 -or $_.grade -lt 100 -or $_.standardization.grade -lt 100 } |
  Select-Object name, blocs, filesNoEquatable, grade, @{N='std';E={$_.standardization.grade}} |
  Format-Table -AutoSize
