@echo off

:: Git related commands
echo git push -u origin new>> C:\Users\Admin\.bash_history
echo git push -f origin new>> C:\Users\Admin\.bash_history
echo git commit -s -m "spes: massage">> C:\Users\Admin\.bash_history
echo git commit --amend --no-edit>> C:\Users\Admin\.bash_history
echo git commit --amend --author "usename <user.email.github.com>">> C:\Users\Admin\.bash_history
echo git reset --hard (commit-hash)>> C:\Users\Admin\.bash_history
echo git reset --hard HEAD~2>> C:\Users\Admin\.bash_history
echo git rebase -i HEAD~3>> C:\Users\Admin\.bash_history
echo git log --oneline -5>> C:\Users\Admin\.bash_history
echo git rev-list --count 13.0>> C:\Users\Admin\.bash_history
echo git cherry-pick (commit-hash)>> C:\Users\Admin\.bash_history
echo git init>> C:\Users\Admin\.bash_history
echo git add .>> C:\Users\Admin\.bash_history
echo notepad file.txt>> C:\Users\Admin\.bash_history
echo ssh -T git@github.com>> C:\Users\Admin\.bash_history
echo git clone git@github.com:sakshiagrwal/android.git>> C:\Users\Admin\.bash_history
echo git push origin -d rice "rice is branch name or `-d` means delete the branch">> C:\Users\Admin\.bash_history
echo git remote set-url origin git@github.com:sakshiagrwal/android.git>> C:\Users\Admin\.bash_history
echo .bash_history created.

:: Git config file
echo [user]> C:\Users\Admin\.gitconfig
echo		name = Sakshi Aggarwal>> C:\Users\Admin\.gitconfig
echo		email = 81718060+sakshiagrwal@users.noreply.github.com>> C:\Users\Admin\.gitconfig
echo		signingkey = 6EB51B3E1C6B549F>> C:\Users\Admin\.gitconfig
echo [gpg]>> C:\Users\Admin\.gitconfig
echo		program = C:\\Program Files (x86)\\GnuPG\\bin\\gpg.exe>> C:\Users\Admin\.gitconfig
echo [commit]>> C:\Users\Admin\.gitconfig
echo		gpgsign = true>> C:\Users\Admin\.gitconfig
echo [core]>> C:\Users\Admin\.gitconfig
echo		autocrlf = false>> C:\Users\Admin\.gitconfig
echo .gitconfig created.

:: Mintty config file
echo Columns=120> C:\Users\Admin\.minttyrc
echo Rows=25>> C:\Users\Admin\.minttyrc
echo ThemeFile=flat-ui>> C:\Users\Admin\.minttyrc
echo Font=Cascadia Mono>> C:\Users\Admin\.minttyrc
echo .minttyrc created.

pause
