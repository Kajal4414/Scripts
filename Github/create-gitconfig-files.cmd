@echo off

set HISTORY_FILE=%USERPROFILE%\.bash_history
set GITCONFIG_FILE=%USERPROFILE%\.gitconfig
set MINTYRC_FILE=%USERPROFILE%\.minttyrc

rem Git related commands
echo git push -u origin new> %HISTORY_FILE%
echo git push -f origin new>> %HISTORY_FILE%
echo git commit -s -m "file: massage">> %HISTORY_FILE%
echo git commit --amend --no-edit>> %HISTORY_FILE%
echo git commit --amend --author "usename <user.email.github.com>">> %HISTORY_FILE%
echo git reset --hard (commit-hash)>> %HISTORY_FILE%
echo git reset --hard HEAD~2>> %HISTORY_FILE%
echo git rebase -i HEAD~3>> %HISTORY_FILE%
echo git log --oneline -5>> %HISTORY_FILE%
echo git rev-list --count 13.0>> %HISTORY_FILE%
echo git cherry-pick (commit-hash)>> %HISTORY_FILE%
echo git init>> %HISTORY_FILE%
echo git add .>> %HISTORY_FILE%
echo notepad file.txt>> %HISTORY_FILE%
echo ssh -T git@github.com>> %HISTORY_FILE%
echo git clone git@github.com:sakshiagrwal/android.git>> %HISTORY_FILE%
echo git push origin -d rice>> %HISTORY_FILE%
echo git remote set-url origin git@github.com:sakshiagrwal/android.git>> %HISTORY_FILE%
echo Successfully created the .bash_history file at %HISTORY_FILE%

rem Git config file
echo [user]> %GITCONFIG_FILE%
echo		name = Sakshi Aggarwal>> %GITCONFIG_FILE%
echo		email = 81718060+sakshiagrwal@users.noreply.github.com>> %GITCONFIG_FILE%
echo		signingkey = 6EB51B3E1C6B549F>> %GITCONFIG_FILE%
echo [gpg]>> %GITCONFIG_FILE%
echo		program = C:/Program Files (x86)/GnuPG/bin/gpg.exe>> %GITCONFIG_FILE%
echo [commit]>> %GITCONFIG_FILE%
echo		gpgsign = true>> %GITCONFIG_FILE%
echo [core]>> %GITCONFIG_FILE%
echo		editor = notepad>> %GITCONFIG_FILE%
echo		autocrlf = false>> %GITCONFIG_FILE%
echo Successfully created the .gitconfig file at %GITCONFIG_FILE%

rem Mintty config file
echo Columns=120> %MINTYRC_FILE%
echo Rows=25>> %MINTYRC_FILE%
echo ThemeFile=flat-ui>> %MINTYRC_FILE%
echo Font=Cascadia Mono>> %MINTYRC_FILE%
echo Successfully created the .minttyrc file at %MINTYRC_FILE%

pause
