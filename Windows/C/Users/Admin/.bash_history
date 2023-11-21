git push -u origin new # Push new branch "new" to remote repository "origin" and set it as default branch for future pushes
git push -f origin new # Force push the branch "new" to remote repository "origin"
git commit -s -m "file: massage" # Commit changes in the repository with the commit message "file: massage" and sign it with your GPG key
git commit --amend --no-edit # Amend the latest commit in the repository without modifying the commit message
git commit --amend --author "usename <user.email.github.com>" # Amend the latest commit in the repository and set a new author
git reset --hard (commit-hash) # Hard reset the repository to a specific commit identified by its hash
git reset --hard HEAD~2 # Hard reset the repository to the state it was in 2 commits ago
git rebase -i HEAD~3 # Rebase the last 3 commits interactively
git log --oneline -5 # Show the 5 most recent commits in the repository in a condensed one-line format
git rev-list --count 13.0 # Show the number of commits in the repository reachable from a specified branch or tag
git cherry-pick (commit-hash) # Apply the changes of a specific commit to the current branch
git init # Initialize a Git repository in the current directory
git add . # Stage all changes in the repository for the next commit
notepad file.txt # Open the file "file.txt" in Notepad (for Windows)
ssh -T git@github.com # Establish an SSH connection to GitHub
git clone git@github.com:sakshiagrwal/android.git # Clone the repository "android" from the user "sakshiagrwal" on GitHub to the current directory
git push origin -d rice # Delete the remote branch "rice" from the remote repository "origin"
git remote set-url origin git@github.com:sakshiagrwal/android.git # Change the URL of the remote repository "origin" to "git@github.com:sakshiagrwal/android.git"
