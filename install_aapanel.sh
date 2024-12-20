#!/bin/bash

# Função para exibir título
function print_title() {
    echo "====================================="
    echo "$1"
    echo "====================================="
}

# Solicitar portas e domínios ao usuário
print_title "Configuração Inicial do aaPanel"
read -p "Digite a porta HTTP para o painel (padrão: 80): " http_port
http_port=${http_port:-80}

read -p "Digite a porta HTTPS para o painel (padrão: 443): " https_port
https_port=${https_port:-443}

read -p "Digite o domínio para o painel (ex.: painel.seudominio.com): " panel_domain

# Atualizar e instalar dependências básicas
print_title "Atualizando o sistema e instalando dependências..."
apt-get update -y && apt-get upgrade -y
apt-get install -y curl wget

# Baixar o script de instalação do aaPanel
print_title "Baixando o script de instalação do aaPanel..."
URL="https://www.aapanel.com/script/install_7.0_en.sh"
if [ -f /usr/bin/curl ]; then
    curl -ksSO "$URL"
else
    wget --no-check-certificate -O install_7.0_en.sh "$URL"
fi

# Editar o script de instalação para evitar a instalação do nginx
print_title "Modificando o script para evitar a instalação do Nginx..."
sed -i 's/apt-get install -y nginx/#apt-get install -y nginx/' install_7.0_en.sh

# Executar o script de instalação do aaPanel
print_title "Instalando o aaPanel..."
bash install_7.0_en.sh

# Configurar aaPanel
print_title "Configurando o aaPanel..."
if [[ -n "$http_port" && -n "$https_port" ]]; then
    echo "Alterando as portas padrão..."
    # Exemplo fictício para configurar as portas - ajuste conforme necessário
    sed -i "s/80/$http_port/" /www/server/panel/data/config.json
    sed -i "s/443/$https_port/" /www/server/panel/data/config.json
fi

if [[ -n "$panel_domain" ]]; then
    echo "Configurando domínio: $panel_domain..."
    # Exemplo fictício para configurar o domínio - ajuste conforme necessário
    echo "domain=$panel_domain" > /www/server/panel/data/domain.conf
fi

# Finalizar instalação
print_title "Instalação do aaPanel Concluída!"
echo "Acesse o painel pelo domínio: http://$panel_domain (porta $http_port)"
