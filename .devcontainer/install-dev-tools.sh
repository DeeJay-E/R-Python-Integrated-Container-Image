# update system
apt-get update
apt-get upgrade -y

# install Linux tools and Python 3.12
apt-get install software-properties-common wget curl \
    python3.12-dev python3.12-venv python3-pip python3-wheel python3-setuptools -y

# Create symbolic links for Python 3.12
ln -sf /usr/bin/python3.12 /usr/bin/python3
ln -sf /usr/bin/python3.12 /usr/bin/python

# install Python packages using Python 3.12
python3.12 -m pip install --upgrade pip

# Check if requirements.txt exists before trying to install from it
if [ -f ".devcontainer/requirements.txt" ]; then
    pip3 install --user -r .devcontainer/requirements.txt
else
    echo "No requirements.txt found, skipping pip install"
fi

# Install additional R packages for data science
echo "Installing additional R packages for data science..."
R --slave --no-restore --file=/dev/stdin <<EOF
# Install additional data science packages
install.packages(c(
    "plotly",
    "DT",
    "reticulate",
    "tensorflow",
    "keras",
    "torch"
), repos="https://cloud.r-project.org/", dependencies=TRUE)
EOF

# update CUDA Linux GPG repository key for Ubuntu 24.04
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-keyring_1.1-1_all.deb
dpkg -i cuda-keyring_1.1-1_all.deb
rm cuda-keyring_1.1-1_all.deb

# install cuDNN for Ubuntu 24.04
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/3bf863cc.pub
add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/ /" -y
apt-get update

# Install cuDNN (adjust version as needed for CUDA 12.4)
apt-get install -y libcudnn8 libcudnn8-dev

# install recommended packages
apt-get install zlib1g g++ freeglut3-dev \
    libx11-dev libxmu-dev libxi-dev libglu1-mesa libglu1-mesa-dev libfreeimage-dev -y

# clean up
if command -v pip3 &> /dev/null; then
    pip3 cache purge
fi
apt-get autoremove -y
apt-get clean