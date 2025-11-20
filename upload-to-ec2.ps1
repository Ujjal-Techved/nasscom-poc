# PowerShell Script to Upload Files to EC2
# Run this from your local Windows machine

param(
    [Parameter(Mandatory=$true)]
    [string]$EC2IP,
    
    [Parameter(Mandatory=$true)]
    [string]$KeyPath,
    
    [Parameter(Mandatory=$false)]
    [string]$User = "ubuntu"
)

Write-Host "🚀 Uploading files to EC2 instance..." -ForegroundColor Cyan

$files = @(
    "nginx.conf",
    "setup-server.sh",
    "deploy.sh"
)

foreach ($file in $files) {
    if (Test-Path $file) {
        Write-Host "📤 Uploading $file..." -ForegroundColor Yellow
        scp -i $KeyPath $file "${User}@${EC2IP}:~/"
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ $file uploaded successfully" -ForegroundColor Green
        } else {
            Write-Host "❌ Failed to upload $file" -ForegroundColor Red
        }
    } else {
        Write-Host "⚠️  File not found: $file" -ForegroundColor Yellow
    }
}

Write-Host "`n✅ Upload complete!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. SSH into your EC2 instance:" -ForegroundColor White
Write-Host "   ssh -i $KeyPath ${User}@${EC2IP}" -ForegroundColor Gray
Write-Host "2. Make scripts executable:" -ForegroundColor White
Write-Host "   chmod +x setup-server.sh deploy.sh" -ForegroundColor Gray
Write-Host "3. Run the setup:" -ForegroundColor White
Write-Host "   ./setup-server.sh" -ForegroundColor Gray

