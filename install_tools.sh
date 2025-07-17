#!/usr/bin/env bash
set -e

echo "Detecting OS..."

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macos"
elif [[ "$OSTYPE" == "msys"* || "$OSTYPE" == "cygwin"* ]]; then
  OS="windows"
else
  echo "Unsupported OS: $OSTYPE"
  exit 1
fi

install_terraform() {
  echo "Installing Terraform..."
  if [ "$OS" = "macos" ]; then
    if command -v brew &>/dev/null; then
      brew install terraform
    else
      echo "Homebrew not found. Please install Homebrew first: https://brew.sh/"
      exit 1
    fi
  elif [ "$OS" = "linux" ]; then
    wget https://releases.hashicorp.com/terraform/1.8.4/terraform_1.8.4_linux_amd64.zip -O terraform.zip
    unzip terraform.zip
    sudo mv terraform /usr/local/bin/
    rm terraform.zip
  else
    echo "Please install Terraform manually from https://terraform.io/downloads"
  fi
}

install_helm() {
  echo "Installing Helm..."
  if [ "$OS" = "macos" ]; then
    brew install helm
  elif [ "$OS" = "linux" ]; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
  else
    echo "Please install Helm manually from https://helm.sh/docs/intro/install/"
  fi
}

install_kind() {
  echo "Installing Kind..."
  if [ "$OS" = "macos" ]; then
    brew install kind
  elif [ "$OS" = "linux" ]; then
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
  else
    echo "Please install Kind manually from https://kind.sigs.k8s.io/docs/user/quick-start/"
  fi
}

check_docker() {
  if ! command -v docker &>/dev/null; then
    echo "Docker is not installed or not in PATH."
    echo "Please install Docker manually from:"
    echo "https://docs.docker.com/get-docker/"
    exit 1
  else
    echo "Docker is already installed."
  fi
}

# Check Docker first
check_docker

# Check and optionally install terraform, helm, and kind
for tool in terraform helm kind; do
  if ! command -v $tool &>/dev/null; then
    read -p "$tool is missing. Install it now? (y/n) " yn
    case $yn in
      [Yy]* ) install_$tool;;
      * ) echo "Please install $tool manually."; exit 1;;
    esac
  else
    echo "$tool is already installed."
  fi
done

echo "All required tools are installed."
