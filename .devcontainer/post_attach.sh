echo "Configuring git to treat working directory as safe..."
git config --global --add safe.directory $(pwd)

if [ $? -eq 0 ]; then
    echo "Successfully configured git!"
else
    echo "Failed to configure git to treat working directory as safe."
fi

echo ""
echo "Verifying Python 3.12 installation..."
python3.12 --version
python3 --version
python --version

echo ""
echo "Verifying R installation..."
R --version | head -1

echo ""
echo "Adding poetry to path..."
poetry_path="/home/developer/.local/bin"
if [ -d "$poetry_path" ] && [[ ":$PATH:" != *":$poetry_path:"* ]]; then
    PATH="${PATH:+"$PATH:"}$poetry_path"
fi

echo "Checking poetry version..."
echo "Using poetry version:"
poetry --version

if [ $? -eq 0 ]; then
    echo "Successfully installed poetry!"
else
    echo "Failed to install poetry."
fi

echo ""
echo "Creating alias localpy to local Python environment..."

echo 'alias localpy="$(pwd)/.venv/bin/python"' >> ~/.bashrc

if [ $? -eq 0 ]; then
    echo "Alias created! To run a script with your local python use:"
    echo "localpy path/to/script.py"
else
    echo "Failed to create alias."
fi

echo ""
echo "Creating R development aliases and renv helpers..."
echo 'alias rscript="Rscript"' >> ~/.bashrc
echo 'alias rconsole="R --no-save --no-restore"' >> ~/.bashrc
echo 'alias renv_status="R -e \"renv::status()\""' >> ~/.bashrc
echo 'alias renv_install="R -e \"renv::install\""' >> ~/.bashrc
echo 'alias renv_snapshot="R -e \"renv::snapshot()\""' >> ~/.bashrc
echo 'alias renv_restore="R -e \"renv::restore()\""' >> ~/.bashrc

echo ""
echo "Checking renv status..."
cd /workspaces/* 2>/dev/null || cd /workspace 2>/dev/null || cd $(pwd)
if [ -f "renv.lock" ]; then
    echo "renv project detected. Current status:"
    R --slave -e "renv::status()" 2>/dev/null || echo "renv status unavailable"
else
    echo "No renv.lock found. Initialize with: R -e \"renv::init()\""
fi

echo ""
echo "Logged in as user:"
whoami

echo ""
echo "Environment setup complete!"
echo "Python version: $(python3.12 --version)"
echo "R version: $(R --version | head -1)"
echo "Poetry version: $(poetry --version)"
echo ""
echo "Available kernels for Jupyter:"
jupyter kernelspec list
echo ""
echo "Success - ready to develop with Python 3.12 and R!"
echo ""