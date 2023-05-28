#!/bin/bash

date=$(date +"%d/%m/%Y-%H:%M")

# Lista de containers a serem desligados
containers_desligar=("container1" "container2" "container3")

# Limite de memória em porcentagem
limite_memoria=80

# Obtém o uso atual da memória
uso_memoria=$(free | awk 'FNR == 2 {print $3/$2 * 100}')

# Verifica se o uso da memória está acima do limite definido
if [[ $uso_memoria > $limite_memoria ]]; then
  echo "O uso da memória ($uso_memoria%) está acima do limite ($limite_memoria%)" >> ./log/log-$date.log

  # Desliga os containers da lista predefinida
  for container in "${containers_desligar[@]}"; do
    docker stack rm "$container"
    echo "Container $container foi desligado" >> ./log/log-$date.log
  done
fi
