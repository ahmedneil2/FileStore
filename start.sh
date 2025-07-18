#!/bin/bash

# FileStore Bot Quick Start Script
# This script helps you set up and run the FileStore bot locally

echo "🚀 FileStore Bot Quick Start"
echo "=============================="

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3.8 or higher."
    exit 1
fi

echo "✅ Python 3 found: $(python3 --version)"

# Check if pip is installed
if ! command -v pip3 &> /dev/null; then
    echo "❌ pip3 is not installed. Please install pip3."
    exit 1
fi

echo "✅ pip3 found"

# Install requirements
echo "📦 Installing requirements..."
pip3 install -r requirements.txt

if [ $? -ne 0 ]; then
    echo "❌ Failed to install requirements"
    exit 1
fi

echo "✅ Requirements installed successfully"

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "⚠️  .env file not found. Creating from template..."
    cp .env.example .env
    echo "📝 Please edit .env file with your bot credentials:"
    echo "   - TG_BOT_TOKEN (from @BotFather)"
    echo "   - APP_ID and API_HASH (from my.telegram.org)"
    echo "   - CHANNEL_ID (your database channel)"
    echo "   - OWNER_ID (your user ID)"
    echo "   - DATABASE_URL (MongoDB connection string)"
    echo "   - DATABASE_NAME (database name)"
    echo ""
    echo "After editing .env file, run this script again."
    exit 0
fi

echo "✅ .env file found"

# Check if required environment variables are set
source .env

required_vars=("TG_BOT_TOKEN" "APP_ID" "API_HASH" "CHANNEL_ID" "OWNER_ID" "DATABASE_URL" "DATABASE_NAME")
missing_vars=()

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ] || [ "${!var}" = "your_${var,,}_here" ] || [ "${!var}" = "your_bot_token_here" ] || [ "${!var}" = "your_app_id_here" ] || [ "${!var}" = "your_api_hash_here" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -ne 0 ]; then
    echo "❌ Missing or incomplete environment variables:"
    printf '   - %s\n' "${missing_vars[@]}"
    echo ""
    echo "Please edit .env file and set these variables."
    exit 1
fi

echo "✅ All required environment variables are set"

# Run tests
echo "🧪 Running deployment tests..."
python3 test_deployment.py

if [ $? -ne 0 ]; then
    echo "⚠️  Some tests failed. Please check the configuration."
    echo "You can still try to run the bot, but it might not work properly."
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Start the bot
echo "🤖 Starting FileStore Bot..."
echo "Press Ctrl+C to stop the bot"
echo ""

python3 main.py
