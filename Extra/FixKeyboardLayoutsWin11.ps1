# ============================================
# Windows 11 Keyboard Layout Fix
# Clears ghost layouts and keeps only English (India)
# ============================================

Write-Host "🚀 Starting Keyboard Layout Cleanup..." -ForegroundColor Cyan
Start-Sleep -Seconds 1

# 1️⃣  Backup Registry Keys
Write-Host "🗄️  Backing up registry keys to Desktop..." -ForegroundColor Yellow
$backupPath = "$env:USERPROFILE\Desktop\KeyboardLayout_Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $backupPath | Out-Null

reg export "HKCU\Keyboard Layout" "$backupPath\KeyboardLayout_HKCU.reg" > $null
reg export "HKEY_USERS\.DEFAULT\Keyboard Layout" "$backupPath\KeyboardLayout_DEFAULT.reg" > $null
Write-Host "✅ Backup saved to: $backupPath" -ForegroundColor Green
Start-Sleep -Seconds 1

# 2️⃣  Delete ghost layouts
Write-Host "🧹 Cleaning old/duplicate layouts..." -ForegroundColor Yellow
reg delete "HKCU\Keyboard Layout\Preload" /v 1 /f > $null
reg delete "HKEY_USERS\.DEFAULT\Keyboard Layout\Preload" /v 1 /f > $null
reg delete "HKEY_USERS\.DEFAULT\Keyboard Layout\Preload" /v 2 /f > $null
reg delete "HKEY_USERS\.DEFAULT\Keyboard Layout\Preload" /v 3 /f > $null
reg delete "HKEY_USERS\.DEFAULT\Keyboard Layout\Substitutes" /f > $null
Write-Host "✅ Ghost layouts removed." -ForegroundColor Green
Start-Sleep -Seconds 1

# 3️⃣  Recreate clean preload key
Write-Host "🔧 Rebuilding Preload with only English (India)..." -ForegroundColor Yellow
reg add "HKEY_USERS\.DEFAULT\Keyboard Layout\Preload" /v 1 /t REG_SZ /d 00004009 /f > $null
Write-Host "✅ Preload rebuilt successfully." -ForegroundColor Green
Start-Sleep -Seconds 1

# 4️⃣  Rebuild user language list
Write-Host "🌐 Rebuilding Windows language list..." -ForegroundColor Yellow
$LangList = New-WinUserLanguageList en-IN
Set-WinUserLanguageList $LangList -Force
Write-Host "✅ Language list rebuilt (English - India only)." -ForegroundColor Green
Start-Sleep -Seconds 1

# 5️⃣  Restart Explorer for instant effect
Write-Host "♻️  Restarting Explorer..." -ForegroundColor Yellow
taskkill /f /im explorer.exe > $null
Start-Sleep -Seconds 2
Start-Process explorer.exe
Write-Host "✅ Explorer restarted." -ForegroundColor Green
Start-Sleep -Seconds 1

# 6️⃣  Done!
Write-Host "🎉 All done! Only 'ENG IN' should remain in your taskbar." -ForegroundColor Cyan
Write-Host "📦 Registry backups saved at: $backupPath" -ForegroundColor DarkGray
