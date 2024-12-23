#!/bin/bash

# Цвета текста
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Нет цвета (сброс цвета)

# Проверка наличия curl и установка, если не установлен
if ! command -v curl &> /dev/null; then
    echo -e "${YELLOW}Устанавливаем curl...${NC}"
    sudo apt install curl -y
fi

# Логотип
curl -s https://raw.githubusercontent.com/noxuspace/cryptofortochka/main/logo_club.sh | bash

# Меню
echo -e "${YELLOW}Выберите действие:${NC}"
echo -e "${CYAN}1) Установка ноды${NC}"
echo -e "${CYAN}2) Обновление ноды${NC}"
echo -e "${CYAN}3) Проверка логов${NC}"
echo -e "${CYAN}4) Проверка статуса работы ноды${NC}"
echo -e "${CYAN}5) Удаление ноды${NC}"

read -p "Введите номер: " choice

case $choice in
    1)
        echo -e "${CYAN}Устанавливаем ноду Unichain...${NC}"

        # Проверка Docker
        if ! command -v docker &> /dev/null; then
            echo -e "${YELLOW}Docker не установлен. Установите Docker вручную.${NC}"
            exit 1
        fi

        # Проверка Docker Compose
        if ! command -v docker-compose &> /dev/null || [[ $(docker-compose --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -1) < "2.20.2" ]]; then
            echo -e "${YELLOW}Обновляем Docker Compose...${NC}"
            sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
            sudo chmod +x /usr/local/bin/docker-compose
        else
            echo -e "${CYAN}Docker Compose уже установлен и актуален.${NC}"
        fi

        rm -rf unichain-node/

        # Клонируем репозиторий
        if [ ! -d "$HOME/unichain-node" ]; then
            echo -e "${CYAN}Клонируем репозиторий...${NC}"
            git clone https://github.com/Uniswap/unichain-node $HOME/unichain-node
        else
            echo -e "${CYAN}Папка unichain-node уже существует.${NC}"
        fi

        cd $HOME/unichain-node || { echo -e "${RED}Не удалось войти в директорию unichain-node.${NC}"; exit 1; }

        # Удаление start_interval из docker-compose.yml
        if [ -f "docker-compose.yml" ]; then
            echo -e "${CYAN}Удаляем параметр start_interval из docker-compose.yml...${NC}"
            sed -i '/start_interval/d' docker-compose.yml
        fi

        # Проверяем .env.sepolia
        if [ -f ".env.sepolia" ]; then
            sed -i 's|^OP_NODE_L1_ETH_RPC=.*|OP_NODE_L1_ETH_RPC=https://ethereum-sepolia-rpc.publicnode.com|' .env.sepolia
            sed -i 's|^OP_NODE_L1_BEACON=.*|OP_NODE_L1_BEACON=https://ethereum-sepolia-beacon-api.publicnode.com|' .env.sepolia
        else
            echo -e "${RED}Файл .env.sepolia не найден.${NC}"
            exit 1
        fi

        # Запуск контейнеров
        docker-compose up -d
        echo -e "${CYAN}Контейнеры запущены.${NC}"

        # Проверка логов
        echo -e "${CYAN}Проверяем логи...${NC}"
        docker-compose logs -f
        ;;
    2)
        echo -e "${CYAN}Обновление ноды Unichain...${NC}"
        echo -e "${GREEN}Актуальная версия установлена.${NC}"
        ;;
    3)
        echo -e "${CYAN}Просмотр логов Unichain...${NC}"
        cd $HOME/unichain-node && docker-compose logs -f
        ;;
    4)
        echo -e "${CYAN}Проверка статуса работы ноды Unichain...${NC}"
        curl -d '{"id":1,"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["latest",false]}' \
        -H "Content-Type: application/json" http://localhost:8545
        ;;
    5)
        echo -e "${CYAN}Удаление ноды Unichain...${NC}"
        cd $HOME/unichain-node && docker-compose down -v
        rm -rf $HOME/unichain-node
        echo -e "${GREEN}Нода Unichain удалена.${NC}"
        ;;
    *)
        echo -e "${RED}Неверный выбор. Пожалуйста, введите номер от 1 до 5.${NC}"
        ;;
esac
