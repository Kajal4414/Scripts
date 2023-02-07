@echo off

:: Git related commands
echo git push -u origin new # Push new branch "new" to remote repository "origin" and set it as default branch for future pushes>> C:\Users\Admin\.bash_history
echo git push -f origin new # Force push the branch "new" to remote repository "origin">> C:\Users\Admin\.bash_history
echo git commit -s -m "spes: massage" # Commit changes in the repository with the commit message "file: massage" and sign it with your GPG key>> C:\Users\Admin\.bash_history
echo git commit --amend --no-edit>> C:\Users\Admin\.bash_history # Amend the latest commit in the repository without modifying the commit message
echo git commit --amend --author "usename <user.email.github.com>">> C:\Users\Admin\.bash_history # Amend the latest commit in the repository and set a new author
echo git reset --hard (commit-hash)>> C:\Users\Admin\.bash_history # Hard reset the repository to a specific commit identified by its hash
echo git reset --hard HEAD~2>> C:\Users\Admin\.bash_history # Hard reset the repository to the state it was in 2 commits ago
echo git rebase -i HEAD~3>> C:\Users\Admin\.bash_history # Rebase the last 3 commits interactively
echo git log --oneline -5>> C:\Users\Admin\.bash_history # Show the 5 most recent commits in the repository in a condensed one-line format
echo git rev-list --count 13.0>> C:\Users\Admin\.bash_history # Show the number of commits in the repository reachable from a specified branch or tag
echo git cherry-pick (commit-hash)>> C:\Users\Admin\.bash_history # Apply the changes of a specific commit to the current branch
echo git init>> C:\Users\Admin\.bash_history # Initialize a Git repository in the current directory
echo git add . # Stage all changes in the repository for the next commit>> C:\Users\Admin\.bash_history
echo notepad file.txt>> C:\Users\Admin\.bash_history # Open the file "file.txt" in Notepad (for Windows)
echo ssh -T git@github.com # Establish an SSH connection to GitHub>> C:\Users\Admin\.bash_history
echo git clone git@github.com:sakshiagrwal/android.git>> C:\Users\Admin\.bash_history # Clone the repository "android" from the user "sakshiagrwal" on GitHub to the current directory
echo git push origin -d rice # Delete the remote branch "rice" from the remote repository "origin">> C:\Users\Admin\.bash_history
echo git remote set-url origin git@github.com:sakshiagrwal/android.git>> C:\Users\Admin\.bash_history # Change the URL of the remote repository "origin" to "git@github.com:sakshiagrwal/android.git"
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
