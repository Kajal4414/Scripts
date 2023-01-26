# Git Commit Hook to Add Change-Id

Create a new [file](../prepare-commit-msg) named `prepare-commit-msg` in the `.git/hooks` directory of your repository.

```sh
#!/bin/sh

# Check if the commit message already contains "Change-Id:"
if ! grep -q "Change-Id:" "$1"; then
  # If not, add "Change-Id: <commit hash>" to the commit message
  echo "Change-Id: $(git rev-parse HEAD)" >> "$1"
fi
```

Make the prepare-commit-msg file executable by running the following command:

```sh
# Linux
chmod +x .git/hooks/prepare-commit-msg

# Windows
attrib +x prepare-commit-msg
```

You can add this as a code block in your readme.md file and it will be easy for others to understand and can also use it in their projects.
