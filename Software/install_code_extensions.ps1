# https://code.visualstudio.com/docs/editor/extension-marketplace#_command-line-extension-management

# List of extension IDs
$extensions = @(
    "dbaeumer.vscode-eslint",
    "eamodio.gitlens",
    "esbenp.prettier-vscode",
    "foxundermoon.shell-format",
    "github.codespaces",
    "github.github-vscode-theme",
    "jock.svg",
    "ms-python.black-formatter",
    "ms-python.debugpy",
    "ms-python.pylint",
    "ms-python.python",
    "ms-python.vscode-pylance",
    "ms-vscode.cmake-tools",
    "ms-vscode.cpptools",
    "ms-vscode.cpptools-extension-pack",
    "ms-vscode.cpptools-themes",
    "ms-vscode.makefile-tools",
    "ms-vscode.powershell",
    "pkief.material-icon-theme",
    "redhat.java",
    "redhat.vscode-xml",
    "redhat.vscode-yaml",
    "ritwickdey.liveserver",
    "selfrefactor.order-props",
    "twxs.cmake",
    "visualstudioexptteam.intellicode-api-usage-examples",
    "visualstudioexptteam.vscodeintellicode",
    "vscjava.vscode-gradle",
    "vscjava.vscode-java-debug",
    "vscjava.vscode-java-dependency",
    "vscjava.vscode-java-pack"
)

foreach ($extensionId in $extensions) {
    code --install-extension $extensionId
}
