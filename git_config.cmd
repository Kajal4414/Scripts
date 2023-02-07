@echo off

set HISTORY_FILE=C:\Users\Admin\.bash_history
set GITCONFIG_FILE=C:\Users\Admin\.gitconfig
set MINTYRC_FILE=C:\Users\Admin\.minttyrc

:: Git related commands
echo git push -u origin new # Push new branch "new" to remote repository "origin" and set it as default branch for future pushes> %HISTORY_FILE%
echo git push -f origin new # Force push the branch "new" to remote repository "origin">> %HISTORY_FILE%
echo git commit -s -m "file: massage" # Commit changes in the repository with the commit message "file: massage" and sign it with your GPG key>> %HISTORY_FILE%
echo git commit --amend --no-edit # Amend the latest commit in the repository without modifying the commit message>> %HISTORY_FILE%
echo git commit --amend --author "usename <user.email.github.com>" # Amend the latest commit in the repository and set a new author>> %HISTORY_FILE%
echo git reset --hard (commit-hash) # Hard reset the repository to a specific commit identified by its hash>> %HISTORY_FILE%
echo git reset --hard HEAD~2 # Hard reset the repository to the state it was in 2 commits ago>> %HISTORY_FILE%
echo git rebase -i HEAD~3 # Rebase the last 3 commits interactively>> %HISTORY_FILE%
echo git log --oneline -5 # Show the 5 most recent commits in the repository in a condensed one-line format>> %HISTORY_FILE%
echo git rev-list --count 13.0 # Show the number of commits in the repository reachable from a specified branch or tag>> %HISTORY_FILE%
echo git cherry-pick (commit-hash) # Apply the changes of a specific commit to the current branch>> %HISTORY_FILE%
echo git init # Initialize a Git repository in the current directory>> %HISTORY_FILE%
echo git add . # Stage all changes in the repository for the next commit>> %HISTORY_FILE%
echo notepad file.txt # Open the file "file.txt" in Notepad (for Windows)>> %HISTORY_FILE%
echo ssh -T git@github.com # Establish an SSH connection to GitHub>> %HISTORY_FILE%
echo git clone git@github.com:sakshiagrwal/android.git # Clone the repository "android" from the user "sakshiagrwal" on GitHub to the current directory>> %HISTORY_FILE%
echo git push origin -d rice # Delete the remote branch "rice" from the remote repository "origin">> %HISTORY_FILE%
echo git remote set-url origin git@github.com:sakshiagrwal/android.git # Change the URL of the remote repository "origin" to "git@github.com:sakshiagrwal/android.git">> %HISTORY_FILE%
echo .bash_history created.

:: Git config file
echo [user]> %GITCONFIG_FILE%
echo		name = Sakshi Aggarwal>> %GITCONFIG_FILE%
echo		email = 81718060+sakshiagrwal@users.noreply.github.com>> %GITCONFIG_FILE%
echo		signingkey = 6EB51B3E1C6B549F>> %GITCONFIG_FILE%
echo [gpg]>> %GITCONFIG_FILE%
echo		program = C:\\Program Files (x86)\\GnuPG\\bin\\gpg.exe>> %GITCONFIG_FILE%
echo [commit]>> %GITCONFIG_FILE%
echo		gpgsign = true>> %GITCONFIG_FILE%
echo [core]>> %GITCONFIG_FILE%
echo		editor = notepad>> %GITCONFIG_FILE%
echo		autocrlf = false>> %GITCONFIG_FILE%
echo .gitconfig created.

:: Mintty config file
echo Columns=120> %MINTYRC_FILE%
echo Rows=25>> %MINTYRC_FILE%
echo ThemeFile=flat-ui>> %MINTYRC_FILE%
echo Font=Cascadia Mono>> %MINTYRC_FILE%
echo .minttyrc created.

pause
