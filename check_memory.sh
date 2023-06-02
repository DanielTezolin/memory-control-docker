#!/bin/bash

# Função para criar o diretório de log, se ele não existir
function create_log_directory {
  if [ ! -d "./log" ]; then
    mkdir ./log
  fi
}

# Função para obter o uso atual da memória
function get_memory_usage {
  free | awk 'FNR == 2 {print $3/$2 * 100}'
}

# Função para desligar os stacks da lista predefinida
function stop_stacks {
  for stack in "${stacks_desligar[@]}"; do
    docker stack rm "$stack"
    echo "Stack $stack foi desligado" >> ./log/log-$date.log
  done
}

# Função para verificar o uso da memória e desligar os stacks, se necessário
function check_memory {
  # Limite de memória em porcentagem
  local limite_memoria=20

  # Obtém o uso atual da memória
  local uso_memoria=$(get_memory_usage)

  # Verifica se o uso da memória está acima do limite definido
  if [[ $uso_memoria > $limite_memoria ]]; then
    echo "O uso da memória ($uso_memoria%) está acima do limite ($limite_memoria%)" >> ./log/log-$date.log
    stop_stacks
  fi
}

# Data e hora atual
date=$(date +"%d-%m-%Y-%H-%M")

# Lista de stacks a serem desligados
stacks_desligar=("container1" "container2" "container3")

# Cria o diretório de log, se ele não existir
create_log_directory

# Verifica o uso da memória e desliga os stacks, se necessário
check_memory
