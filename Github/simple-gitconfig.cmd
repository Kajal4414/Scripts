@echo off

rem Define the email and username for both users
set user1_email=37282143+Sneha@users.noreply.github.com
set user1_username=Sneha Sharma
set user2_email=81718060+sakshiagrwal@users.noreply.github.com
set user2_username=Sakshi Aggarwal

rem Define the GPG signing key for both users
set user1_signingkey=6EB51B3E1C6B549F
set user2_signingkey=6EB51B3E1C6B549F

rem Define the GPG executable path for both users
set gpg_program=C:/Program Files (x86)/GnuPG/bin/gpg.exe

:start
rem Prompt the user for the number of the user they want to add
set /p choice=Enter the number of the user you want to add (1 for %user1_username%, 2 for %user2_username%):

rem Validate the user input
if not "%choice%" == "1" if not "%choice%" == "2" (
    echo Invalid choice. Please enter either 1 or 2.
    goto start
)

rem Delete the existing .gitconfig file if it exists
if exist %USERPROFILE%\.gitconfig (
    del %USERPROFILE%\.gitconfig
    echo Deleted existing .gitconfig file from %USERPROFILE%
    ) else (
    echo No existing .gitconfig file found in %USERPROFILE%
)

rem Set the email, username, and GPG signing key based on the user's choice
if "%choice%" == "1" (
    set email=%user1_email%
    set username=%user1_username%
    set signingkey=%user1_signingkey%
    set user=%user1_username%
    ) else (
    set email=%user2_email%
    set username=%user2_username%
    set signingkey=%user2_signingkey%
    set user=%user2_username%
)

rem Create the .gitconfig file
echo [user]> %USERPROFILE%\.gitconfig
echo 	name = %username%>> %USERPROFILE%\.gitconfig
echo 	email = %email%>> %USERPROFILE%\.gitconfig
echo 	signingkey = %signingkey%>> %USERPROFILE%\.gitconfig
echo [gpg]>> %USERPROFILE%\.gitconfig
echo 	program = %gpg_program%>> %USERPROFILE%\.gitconfig
echo [commit]>> %USERPROFILE%\.gitconfig
echo 	gpgsign = true>> %USERPROFILE%\.gitconfig
echo [core]>> %USERPROFILE%\.gitconfig
echo 	autocrlf = false>> %USERPROFILE%\.gitconfig
echo 	editor = 'C:/Program Files/Notepad++/notepad++.exe' -multiInst -notabbar -nosession -noPlugin>> %USERPROFILE%\.gitconfig

echo The .gitconfig file has been successfully created for %user% in %USERPROFILE%
timeout /t 5
