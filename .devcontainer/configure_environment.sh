export DEBIAN_FRONTEND=noninteractive

# ==========================
# Basic package installation
# ==========================

echo "Installing basic packages for Python 3.12..."

apt-get -y update \
&& apt-get install -yq curl vim git python3.12 python3.12-dev python3.12-venv python3-pip npm \
    software-properties-common wget build-essential \
&& apt-get clean

if [ $? -eq 0 ]; then
    echo "Basic packages installed!"
else
    echo "Failed to install basic packages."
    exit 1
fi

echo "root ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

if grep -q "^root ALL=(ALL) NOPASSWD:ALL" /etc/sudoers; then
    echo "Enabled sudo for root!"
else
    echo "Failed to enable sudo for root."
    exit 1
fi

# Create symbolic links for python3.12
echo "Creating Python 3.12 symbolic links..."
ln -sf /usr/bin/python3.12 /usr/bin/python3
ln -sf /usr/bin/python3.12 /usr/bin/python

# Upgrade pip for Python 3.12
echo "Upgrading pip for Python 3.12..."
python3.12 -m pip install --upgrade pip

user_name="developer"
group_name="developer"

developer_home="/home/$user_name"

# ===================
# Poetry installation
# ===================

poetry_dir=".local/bin"
poetry_command="$developer_home/$poetry_dir/poetry"
install_command="curl -sSL https://install.python-poetry.org | python3.12 -"

echo "Installing Poetry for Python 3.12..."

sudo -u "$user_name" bash -c "$install_command"

if "$poetry_command" --version &>/dev/null; then
    echo "Poetry installed!"
else
    echo "Failed to install Poetry."
fi

echo "Adding Poetry to path..."

echo "export PATH=\"$developer_home/$poetry_dir:\$PATH\"" >> $developer_home/.bashrc

echo "Configuring Poetry virtual environments..."

sudo -u "$user_name" "$poetry_command" config virtualenvs.in-project true

echo "Installing repository dependencies..."

sudo -u "$user_name" "$poetry_command" install --with dev --no-root

if [ $? -eq 0 ]; then
    echo "Repository dependencies installed!"
else
    echo "Failed to install repository dependencies."
fiexport DEBIAN_FRONTEND=noninteractive

# ==========================
# Basic package installation
# ==========================

echo "Installing basic packages for Python 3.12 and R..."

apt-get -y update \
&& apt-get install -yq curl vim git python3.12 python3.12-dev python3.12-venv python3-pip npm \
    software-properties-common wget build-essential \
    dirmngr gnupg apt-transport-https ca-certificates \
    libcurl4-openssl-dev libssl-dev libxml2-dev \
&& apt-get clean

if [ $? -eq 0 ]; then
    echo "Basic packages installed!"
else
    echo "Failed to install basic packages."
    exit 1
fi

echo "root ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

if grep -q "^root ALL=(ALL) NOPASSWD:ALL" /etc/sudoers; then
    echo "Enabled sudo for root!"
else
    echo "Failed to enable sudo for root."
    exit 1
fi

# ================
# R Installation
# ================

echo "Installing R..."

# Add CRAN repository key and repository
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" -y

# Update package list and install R
apt-get update
apt-get install -y r-base r-base-dev

if [ $? -eq 0 ]; then
    echo "R installed successfully!"
    echo "R version: $(R --version | head -1)"
else
    echo "Failed to install R."
    exit 1
fi

# Install only essential system-level R packages (renv and IRkernel)
echo "Installing essential R packages (renv and IRkernel)..."
R --slave --no-restore --file=/dev/stdin <<EOF
# Install renv for package management
install.packages("renv", repos="https://cloud.r-project.org/", dependencies=TRUE)

# Install IRkernel for Jupyter integration (needs to be system-wide)
install.packages(c("IRkernel", "repr", "IRdisplay", "evaluate", "crayon", "pbdZMQ", "devtools", "uuid", "digest"), repos="https://cloud.r-project.org/", dependencies=TRUE)
IRkernel::installspec(user = FALSE)

# Install pak for faster package installation (used by renv)
install.packages("pak", repos="https://cloud.r-project.org/")
EOF

if [ $? -eq 0 ]; then
    echo "Essential R packages (renv and IRkernel) installed successfully!"
else
    echo "Failed to install essential R packages."
fi

# Create symbolic links for python3.12
echo "Creating Python 3.12 symbolic links..."
ln -sf /usr/bin/python3.12 /usr/bin/python3
ln -sf /usr/bin/python3.12 /usr/bin/python

# Upgrade pip for Python 3.12
echo "Upgrading pip for Python 3.12..."
python3.12 -m pip install --upgrade pip

user_name="developer"
group_name="developer"

developer_home="/home/$user_name"

# =============================
# Initialize renv for R project
# =============================

echo "Setting up renv for R package management..."

# Create R project structure as the developer user
sudo -u "$user_name" bash -c "
cd $developer_home
if [ ! -f '.Rprofile' ]; then
    # Initialize renv project
    R --slave --no-restore -e \"renv::init(bare = TRUE)\"
    echo 'renv initialized successfully!'
else
    echo 'renv project already initialized'
fi
"