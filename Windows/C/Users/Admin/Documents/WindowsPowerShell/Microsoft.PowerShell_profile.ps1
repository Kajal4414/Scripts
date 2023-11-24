# https://ohmyposh.dev/docs/installation/customize
Clear-Host # clear copyright banner
Set-Location "$env:USERPROFILE\Desktop" # set default working directory
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH/catppuccin_mocha.omp.json" | Invoke-Expression
