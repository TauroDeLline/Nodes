#!/bin/bash

# Цвета текста
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # Нет цвета (сброс цвета)

# Проверка наличия curl и установка, если не установлен
if ! command -v curl &> /dev/null; then
    echo -e "${BLUE}Устанавливаем curl...${NC}"
    sudo apt update
    sudo apt install curl -y
fi
sleep 1

# Установка Docker и Docker Compose
if ! command -v docker &> /dev/null; then
    echo -e "${BLUE}Docker не установлен. Устанавливаем Docker...${NC}"
    sudo apt install docker.io -y
fi

if ! command -v docker-compose &> /dev/null; then
    echo -e "${BLUE}Docker Compose не установлен. Устанавливаем Docker Compose...${NC}"
    sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Клонирование репозитория
REPO_DIR="$PWD"
if [ ! -d "$REPO_DIR/Unichain" ]; then
    echo -e "${BLUE}Клонируем репозиторий Unichain...${NC}"
    git clone https://github.com/Uniswap/unichain-node "$REPO_DIR/Unichain"
else
    echo -e "${BLUE}Репозиторий уже клонирован. Пропускаем...${NC}"
fi

cd "$REPO_DIR/Unichain" || { echo -e "${RED}Ошибка: не удалось перейти в директорию $REPO_DIR/Unichain.${NC}"; exit 1; }

# Настройка .env.sepolia
ENV_FILE=".env.sepolia"
if [ -f "$ENV_FILE" ]; then
    echo -e "${BLUE}Настраиваем файл .env.sepolia...${NC}"
    sed -i 's|^OP_NODE_L1_ETH_RPC=.*|OP_NODE_L1_ETH_RPC=https://ethereum-sepolia-rpc.publicnode.com|' "$ENV_FILE"
    sed -i 's|^OP_NODE_L1_BEACON=.*|OP_NODE_L1_BEACON=https://ethereum-sepolia-beacon-api.publicnode.com|' "$ENV_FILE"
    sed -i 's|^OP_NODE_L2_ENGINE_RPC=.*|OP_NODE_L2_ENGINE_RPC=http://Unichain-execution-client:8551|' "$ENV_FILE"
else
    echo -e "${RED}Ошибка: файл $ENV_FILE не найден.${NC}"
    exit 1
fi

# Создание JWT-файла
JWT_FILE="$REPO_DIR/Unichain/shared/jwt.hex"
mkdir -p "$REPO_DIR/Unichain/shared"
if [ ! -f "$JWT_FILE" ]; then
    echo -e "${BLUE}Создаем JWT файл...${NC}"
    openssl rand -hex 32 > "$JWT_FILE"
fi

# Проверка доступности портов и настройка docker-compose.yml
function check_port() {
    local port=$1
    if ss -tuln | grep -q ":$port"; then
        echo "false"
    else
        echo "true"
    fi
}

BASE_RPC_PORT=8545
BASE_P2P_PORT=30303
RPC_PORT=$BASE_RPC_PORT
P2P_PORT=$BASE_P2P_PORT

while [ "$(check_port $RPC_PORT)" = "false" ]; do
    RPC_PORT=$((RPC_PORT + 1))
done

while [ "$(check_port $P2P_PORT)" = "false" ]; do
    P2P_PORT=$((P2P_PORT + 1))
done

sed -i "s|8545|$RPC_PORT|g" docker-compose.yml
sed -i "s|30303|$P2P_PORT|g" docker-compose.yml

# Запуск контейнеров
echo -e "${BLUE}Запускаем контейнеры...${NC}"
docker-compose down
if docker-compose up -d; then
    echo -e "${GREEN}Контейнеры успешно запущены.${NC}"
else
    echo -e "${RED}Ошибка при запуске контейнеров.${NC}"
    exit 1
fi

# Информация о логах
echo -e "${YELLOW}Для просмотра логов выполните:${NC}"
echo -e "docker-compose logs -f"
