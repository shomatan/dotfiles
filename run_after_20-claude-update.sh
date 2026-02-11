#!/bin/bash

# Update Claude Code
if command -v claude &> /dev/null; then
    echo "Updating Claude Code..."
    claude update
else
    echo "Warning: Claude Code is not installed"
fi
