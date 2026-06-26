# https://code.visualstudio.com/docs/editor/extension-marketplace#_command-line-extension-management

# List of extension IDs
$extensions = @(
    "dbaeumer.vscode-eslint",
    "eamodio.gitlens",
    "esbenp.prettier-vscode",
    "github.github-vscode-theme",
    "jock.svg",
    "pkief.material-icon-theme",
    "redhat.vscode-yaml",
    "ritwickdey.liveserver",
    "usernamehw.errorlens"
)

foreach ($extensionId in $extensions) {
    code --install-extension $extensionId
}
