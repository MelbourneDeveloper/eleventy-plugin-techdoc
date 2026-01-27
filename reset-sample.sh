#!/bin/bash
# Resets sample_website and scaffolds fresh from techdoc

cd "$(dirname "$0")/.." || exit 1

# Kill any running eleventy dev server
pkill -f "eleventy --serve" 2>/dev/null || true
lsof -ti:8080 | xargs kill 2>/dev/null || true

rm -rf sample_website
mkdir sample_website
cd sample_website

npm init -y
npm install @11ty/eleventy ../techdoc
node ../techdoc/bin/init.js

npm run dev
