# Git Commit Hook to Add Change-Id

Create a new [file](./prepare-commit-msg) named `prepare-commit-msg` in the `.git/hooks` directory of your repository:

```sh
# Linux
touch .git/hooks/prepare-commit-msg

# Windows
type nul > .git/hooks/prepare-commit-msg
```

Open the file using a text editor:

```sh
# GNU Nano
nano .git/hooks/prepare-commit-msg

# Visual Studio Code
code .git/hooks/prepare-commit-msg

# Windows Notepad
notepad .git/hooks/prepare-commit-msg
```

Add the following content to the [file](./prepare-commit-msg):

```sh
#!/bin/sh

# Generate a new change ID using the current commit hash and the committer email address
change_id="Change-Id: I$(git rev-parse HEAD | openssl sha1 | sed 's/^.* //')"

# Check if the commit message already contains a change ID
if ! grep -q "Change-Id:" "$1"; then
  # If not, add the generated change ID to the commit message
  echo "$change_id" >> "$1"
fi
```

Make the prepare-commit-msg file executable by running the following command:

```sh
# Linux
chmod u+x .git/hooks/prepare-commit-msg

# Windows
attrib +x .git/hooks/prepare-commit-msg
```

_Now, every time you run git commit, the prepare-commit-msg hook will run and add a unique Change-Id to the commit message, based on the current commit's hash._
