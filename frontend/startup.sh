#!/bin/bash

# Azure Web App startup script for Node.js/Vite static site
# This script serves the built Vite application

echo "🚀 Starting Ripper ERP Frontend..."
echo "📦 Node version: $(node --version)"
echo "📦 NPM version: $(npm --version)"

# Check if dist directory exists
if [ ! -d "dist" ]; then
    echo "❌ Error: dist directory not found!"
    echo "📁 Current directory contents:"
    ls -la
    exit 1
fi

echo "✅ Found dist directory"
echo "📁 Dist contents:"
ls -la dist/

# Install serve globally if not present
if ! command -v serve &> /dev/null; then
    echo "📦 Installing serve..."
    npm install -g serve
fi

# Serve the built application
echo "🌐 Starting server on port ${PORT:-8080}..."
npx serve -s dist -l ${PORT:-8080}
