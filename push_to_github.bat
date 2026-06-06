@echo off
title Push Tata Play IPTV to GitHub
cd /d "%~dp0"

echo ==================================================
echo         PREPARING GIT REPOSITORY FOR UPLOAD
echo ==================================================
echo.

:: Check if git is installed
where git >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Git is not installed or not in your system PATH.
    echo Please install Git from https://git-scm.com/ or upload files manually to GitHub website.
    echo.
    pause
    exit /b 1
)

:: Create simple .gitignore to avoid uploading guest credentials or cached URLs
if not exist ".gitignore" (
    echo Creating .gitignore file...
    echo app/data/guest-device.cred > .gitignore
    echo app/data/login.json >> .gitignore
    echo app/data/cache_urls.json >> .gitignore
    echo app/data/cache_kid.json >> .gitignore
)

:: Step 1: Initialize Git
if not exist ".git" (
    echo Initializing Git repository...
    git init
) else (
    echo Git repository already initialized.
)

:: Step 2: Add all source files
echo Staging Tata Play files...
git add .

:: Step 3: Commit
echo Committing files...
git commit -m "Initial commit of TataPlay IPTV service"

:: Step 4: Ask for GitHub URL
echo.
echo Please create a new PRIVATE repository on GitHub (https://github.com/new).
echo (Choose Private to prevent sharing your script endpoint publicly, if desired.)
echo Copy the repository URL (it should look like: https://github.com/username/repo-name.git).
echo.
set /p repo_url="Paste your GitHub repository URL: "

if not defined repo_url (
    echo [ERROR] Repository URL cannot be empty.
    pause
    exit /b 1
)

:: Step 5: Configure branch & remote
echo Configuring branch and remote origin...
git branch -M main
git remote remove origin >nul 2>&1
git remote add origin "%repo_url%"

:: Step 6: Push to GitHub
echo.
echo Pushing files to GitHub...
git push -u origin main --force

if %ERRORLEVEL% eq 0 (
    echo.
    echo ==================================================
    echo         UPLOADED SUCCESSFULLY TO GITHUB!
    echo ==================================================
    echo Now open Render.com:
    echo 1. Create a "New Web Service"
    echo 2. Link your new GitHub repository
    echo 3. Environment: PHP
    echo 4. Start Command: php -S 0.0.0.0:$PORT
    echo ==================================================
) else (
    echo.
    echo [ERROR] Failed to push to GitHub. 
    echo Please ensure the URL is correct and you have authenticated with Git.
)

echo.
pause
