#!/bin/bash

# Verifica se está rodando como root
if [[ $(id -u) -ne 0 ]]; then
    echo "Este script precisa ser executado como root!"
    exit 1
fi

echo "Iniciando configuração da infraestrutura..."

# Definição de grupos
GRUPOS=("admin" "desenvolvedores" "suporte")

for grupo in "${GRUPOS[@]}"; do
    if ! grep -q "^$grupo:" /etc/group; then
        groupadd "$grupo"
        echo "Grupo '$grupo' criado."
    else
        echo "Grupo '$grupo' já existe."
    fi
done

# Definição de usuários e atribuição de grupos
USUARIOS=(
    "ana:admin"
    "carlos:desenvolvedores"
    "mariana:suporte"
)

for usuario in "${USUARIOS[@]}"; do
    IFS=":" read -r nome grupo <<< "$usuario"
    
    if ! id "$nome" &>/dev/null; then
        useradd -m -s /bin/bash -G "$grupo" "$nome"
        echo "$nome:Senha123" | chpasswd
        echo "Usuário '$nome' criado e adicionado ao grupo '$grupo'."
    else
        echo "Usuário '$nome' já existe."
    fi
done

# Criar diretórios e configurar permissões
DIRETORIOS=("/publico" "/admin" "/dev" "/suporte")

for dir in "${DIRETORIOS[@]}"; do
    mkdir -p "$dir"
    chmod 770 "$dir"
    echo "Diretório '$dir' criado com permissões 770."
done

# Atribuir grupos aos diretórios
chown root:admin /admin
chown root:desenvolvedores /dev
chown root:suporte /suporte
chmod 777 /publico

echo "Configuração concluída com sucesso!"