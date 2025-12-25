#!/bin/bash

# FMP MCP Server Startup Script
# This script starts the Financial Modeling Prep MCP server on port 8080

echo "==================================================="
echo "  Starting FMP MCP Server"
echo "==================================================="
echo ""

# Check if FMP_ACCESS_TOKEN is set
if [ -z "$FMP_ACCESS_TOKEN" ]; then
    echo "❌ Error: FMP_ACCESS_TOKEN environment variable is not set"
    echo ""
    echo "Please set your FMP API key:"
    echo "  export FMP_ACCESS_TOKEN=your_api_key_here"
    echo ""
    echo "Or run this script with the API key:"
    echo "  FMP_ACCESS_TOKEN=your_api_key ./start-fmp-server.sh"
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
