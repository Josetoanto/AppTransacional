Write-Output "Running module and CI checks..."

flutter analyze
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter test test/features
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

flutter build web
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Output "Manual smoke flow:"
Write-Output "1) Login/Register"
Write-Output "2) Home fetch list"
Write-Output "3) Create hilo"
Write-Output "4) Edit hilo"
Write-Output "5) Delete hilo"
Write-Output "All checks completed successfully."
