@echo off
title FileStore Bot Quick Start

echo 🚀 FileStore Bot Quick Start
echo ==============================

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Python is not installed. Please install Python 3.8 or higher.
    pause
    exit /b 1
)

echo ✅ Python found
python --version

REM Check if pip is installed
pip --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ pip is not installed. Please install pip.
    pause
    exit /b 1
)

echo ✅ pip found

REM Install requirements
echo 📦 Installing requirements...
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo ❌ Failed to install requirements
    pause
    exit /b 1
)

echo ✅ Requirements installed successfully

REM Check if .env file exists
if not exist ".env" (
    echo ⚠️  .env file not found. Creating from template...
    copy .env.example .env
    echo 📝 Please edit .env file with your bot credentials:
    echo    - TG_BOT_TOKEN (from @BotFather^)
    echo    - APP_ID and API_HASH (from my.telegram.org^)
    echo    - CHANNEL_ID (your database channel^)
    echo    - OWNER_ID (your user ID^)
    echo    - DATABASE_URL (MongoDB connection string^)
    echo    - DATABASE_NAME (database name^)
    echo.
    echo After editing .env file, run this script again.
    pause
    exit /b 0
)

echo ✅ .env file found

REM Run tests
echo 🧪 Running deployment tests...
python test_deployment.py
if %errorlevel% neq 0 (
    echo ⚠️  Some tests failed. Please check the configuration.
    echo You can still try to run the bot, but it might not work properly.
    set /p continue="Do you want to continue anyway? (y/N): "
    if /i not "%continue%"=="y" (
        pause
        exit /b 1
    )
)

REM Start the bot
echo 🤖 Starting FileStore Bot...
echo Press Ctrl+C to stop the bot
echo.

python main.py

pause
