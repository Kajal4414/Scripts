# [Git Commit Hook to Add Change-Id](https://gerrit-review.googlesource.com/Documentation/cmd-hook-commit-msg.html)

Create a new [file](./prepare-commit-msg) named `prepare-commit-msg` in the `.git/hooks` directory of your repository:

If you want to use this [hook](./prepare-commit-msg) **globally**, place it in the `C:\Program Files\Git\mingw64\share\git-core\templates\hooks` directory:

```sh
# Linux
touch .git/hooks/prepare-commit-msg

# Windows
type nul > .git/hooks/prepare-commit-msg

# Windows Global
type nul > C:/Program Files/Git/mingw64/share/git-core/templates/hooks/prepare-commit-msg
```

or

```
curl -Lo .git/hooks/commit-msg https://gerrit-review.googlesource.com/tools/hooks/commit-msg
```

Open the file using a text editor:

```sh
# GNU Nano
nano .git/hooks/prepare-commit-msg

# Visual Studio Code
code .git/hooks/prepare-commit-msg

# Windows Notepad
notepad .git/hooks/prepare-commit-msg

# Windows Global
notepad C:/Program Files/Git/mingw64/share/git-core/templates/hooks/prepare-commit-msg
```

Add the following content to the [file](./prepare-commit-msg):

```sh
#!/bin/sh

# Generate a new change ID using the current commit hash and the committer email address
change_id="Change-Id: I$(git rev-parse HEAD | openssl sha1 | sed 's/^.* //')"

# Check if the commit message already contains a change ID
if ! grep -q "^Change-Id:" "$1"; then
  # If the commit message contains a "Signed-off-by" line, add the change ID before it
  if grep -q "^Signed-off-by:" "$1"; then
    sed -i "s/^Signed-off-by:/$change_id\n&/" "$1"
  else
    # If not, add the change ID to the end of the commit message
    echo "$change_id" >> "$1"
  fi
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
