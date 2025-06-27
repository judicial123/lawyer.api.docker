#!/bin/bash

while true; do
  clear
  echo "========== MAIN MENU =========="
  echo "1) Create a new API"
  echo "2) Copy a file to folder"
  echo "3) Create .NET classlib project"
  echo "4) Exit"
  echo "================================"
  read -p "Choose an option [1-4]: " OPTION

  case $OPTION in
    1)
      read -p "Enter API name: " API_NAME
      ./devTools/createSolution.sh "$API_NAME"
      echo "API '$API_NAME' created."
      read -p "Press Enter to continue..."
      ;;
    4)
      echo "Goodbye!"
      exit 0
      ;;
    *)
      echo "Invalid option. Please try again."
      read -p "Press Enter to continue..."
      ;;
  esac
done