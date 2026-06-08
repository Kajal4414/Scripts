# https://code.visualstudio.com/docs/editor/extension-marketplace#_command-line-extension-management

# List of extension IDs
$extensions = @(
    "charliermarsh.ruff",
    "dbaeumer.vscode-eslint",
    "eamodio.gitlens",
    "esbenp.prettier-vscode",
    "github.github-vscode-theme",
    "jock.svg",
    "ms-python.debugpy",
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-python.vscode-python-envs",
    "pkief.material-icon-theme",
    "redhat.vscode-yaml",
    "ritwickdey.liveserver",
    "usernamehw.errorlens"
)

foreach ($extensionId in $extensions) {
    code --install-extension $extensionId
}
