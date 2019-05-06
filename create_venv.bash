#!/bin/bash

function create_venv() {
    echo "Creating .venv folder..."
    if [ ! -d ".venv" ]; then
	mkdir .venv
	echo "Folder created!"
    else
	echo "Folder already exists!"
    fi

    echo "Activating virtual environment..."
    python3 -m venv .venv
    echo "Activated!"
    source .venv/bin/activate
    echo "Installing requirements..."
    python3 -m pip install -r requirements.txt
    deactivate
    echo "Requirements installed!"
}