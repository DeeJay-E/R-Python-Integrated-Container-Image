#!/bin/bash

echo "Running post-start configuration..."

# Configure git safe directory
git config --global --add safe.directory "${PWD}"

if [ $? -eq 0 ]; then
    echo "Git safe directory configured successfully!"
else
    echo "Failed to configure git safe directory."
    exit 1
fi

# Run R environment setup
echo "Setting up R environment with renv..."
Rscript .devcontainer/renv-setup.r

if [ $? -eq 0 ]; then
    echo "R environment setup complete!"
else
    echo "R environment setup failed."
    exit 1
fi

echo "Post-start configuration complete!"