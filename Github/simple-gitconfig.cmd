@echo off

rem Define the email and username for both users
set user1_email=37282143+Sneha@users.noreply.github.com
set user1_username=Sneha Sharma
set user2_email=81718060+sakshiagrwal@users.noreply.github.com
set user2_username=Sakshi Aggarwal

rem Define the signing key for both users
set user1_signingkey=6EB51B3E1C6B549F
set user2_signingkey=6EB51B3E1C6B549F

rem Define the GPG executable path for both users
set gpg_program=C:/Program Files (x86)/GnuPG/bin/gpg.exe

rem Get the choice of user from the user
set /p choice=Enter the number of the user you want to add (1 for Deepak, 2 for Sakshi): 

if exist %USERPROFILE%\.gitconfig (
  rem Delete the existing .gitconfig file
  del %USERPROFILE%\.gitconfig
)

if "%choice%" == "1" (
  rem Get the email, username and GPG signing key for user 1
  set email=%user1_email%
  set username=%user1_username%
  set signingkey=%user1_signingkey%
) else (
  rem Get the email, username and GPG signing key for user 2
  set email=%user2_email%
  set username=%user2_username%
  set signingkey=%user2_signingkey%
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
echo 	editor = notepad>> %USERPROFILE%\.gitconfig

echo .gitconfig file created successfully!
