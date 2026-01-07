#!/bin/bash

# FMP MCP Server Startup Script
# This script starts the Financial Modeling Prep MCP server on port 8080

echo "==================================================="
echo "  Starting FMP MCP Server"
echo "==================================================="
echo ""

# Load environment variables from .env file
if [ -f .env ]; then
    echo "📄 Loading environment variables from .env file..."
    export $(grep -v '^#' .env | grep -v '^$' | xargs)
    echo ""
else
    echo "⚠️  Warning: .env file not found"
    echo "Creating .env template..."
    cat > .env << 'EOF'
# FMP (Financial Modeling Prep) API Configuration
# Get your API key from: https://site.financialmodelingprep.com/developer/docs

FMP_ACCESS_TOKEN=your_api_key_here
EOF
    echo "✓ Created .env file"
    echo "Please edit .env and add your FMP_ACCESS_TOKEN, then run this script again."
    echo ""
    exit 1
fi

# Check if FMP_ACCESS_TOKEN is set
if [ -z "$FMP_ACCESS_TOKEN" ] || [ "$FMP_ACCESS_TOKEN" = "your_api_key_here" ]; then
    echo "❌ Error: FMP_ACCESS_TOKEN is not configured"
    echo ""
    echo "Please edit the .env file and replace 'your_api_key_here' with your actual FMP API key"
    echo ""
    echo "Get your API key from: https://site.financialmodelingprep.com/developer/docs"
    echo ""
    exit 1
fi

# Check if port 8080 is already in use
if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo "⚠️  Warning: Port 8080 is already in use"
    echo ""
    read -p "Kill the existing process? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Killing process on port 8080..."
        lsof -ti:8080 | xargs kill
        sleep 1
    else
        echo "Exiting. Please free port 8080 first."
        exit 1
    fi
fi

echo "🚀 Starting FMP MCP server on port 8080..."
echo "📝 Keep this terminal open while using Claude Code"
echo "🛑 Press Ctrl+C to stop the server"
echo ""

# Start the server
npx -y financial-modeling-prep-mcp-server
