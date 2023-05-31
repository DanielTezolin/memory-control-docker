#!/bin/bash

# Caminho para o script
local_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
script_path="$local_path/check_memory.sh"

# Verifica se o cron job já está configurado
if crontab -l | grep -q "$script_path"; then
  echo "Script já está configurado."
  read -p "Deseja desativar o script? (s/n): " choice

  if [[ $choice == "s" || $choice == "S" ]]; then
    crontab -l | grep -v "$script_path" | crontab -
    echo "Script desativado."
  else
    echo "O script nao foi desativado."
  fi
else
  # Adiciona o cron job para executar o script a cada minuto
  (
    crontab -l
    echo "* * * * * $script_path"
  ) | crontab -
  echo "O script foi configurado para executar a cada minuto."
fi
