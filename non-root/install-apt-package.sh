#!/bin/bash

# Check if .root directory exists, if not create it
if [ ! -d ".root" ]; then
  mkdir .root
fi

# Navigate to the .root directory
cd .root || { echo "Failed to change directory to .root"; exit 1; }

# Prompt the user for the package name
read -p "Enter package name: " package

# Download the specified package using apt-get
apt-get download "$package"

# List the downloaded files and filter for the package
ls | grep "$package"

# Extract the downloaded package
dpkg --extract "$(ls | grep "$package")" .

# Find executable files in the extracted package
find . -name "${package}*" -type f -executable

# Check if the PATH already exists in .bashrc
if ! grep -q 'PATH="$PATH:~/.root/usr/bin"' ~/.bashrc; then
  # Add the extracted package's bin directory to the PATH in .bashrc
  echo 'PATH="$PATH:~/.root/usr/bin"' >> ~/.bashrc
fi
