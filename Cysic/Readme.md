## Быстрый запуск

``` bash
wget https://raw.githubusercontent.com/TauroDeLline/Nodes/main/Cysic/Cysic_Install && chmod +x Cysic_Install && ./Cysic_Install

```

# Установка и запуск ноды Cysic

Этот репозиторий содержит скрипт для автоматизированной установки и запуска ноды Cysic в Docker-контейнере.

## Предварительные требования

- Установленный Docker.
- Файл мнемоники (если имеется) с именем `0x<ваш_адрес>.key` в текущей директории.

## Быстрый старт

wget https://raw.githubusercontent.com/TauroDeLline/Nodes/main/Cysic/Cysic_Install && chmod +x Cysic_Install && ./Cysic_Install


## Ввод данных при запуске

1. У вас уже есть файл мнемоники?  
   Введите `y`, если у вас есть файл мнемоники, или `n`, если вы хотите сгенерировать новый файл.

2. Введите ваш reward address (адрес наград):  
   Укажите ваш адрес в формате `0x...`. Этот адрес используется для привязки вашего узла.

3. Если у вас есть файл мнемоники, укажите его путь:  
   Файл должен находиться в той же директории, что и скрипт, и его имя должно быть в формате `0x<ваш_адрес>.key`.

## Управление нодой

Просмотр логов ноды:

docker logs -f Cysic

Вход внутрь контейнера:

docker exec -it Cysic bash

Повторный запуск скрипта:

./Cysic_Install.sh

## Диагностика

Если контейнер продолжает перезапускаться или возникают ошибки:

1. Просмотрите логи контейнера:

docker logs Cysic

2. Войдите внутрь контейнера для ручной проверки:

docker exec -it Cysic bash

Проверьте наличие файлов:

ls -la /app/
ls -la /root/cysic-verifier/
ls -la /root/.cysic/keys/
ls -la /app/node.log

3. Пересоберите образ без использования кэша:

docker build --no-cache -f Dockerfile.cysic -t cysic:latest .

4. Проверьте выполнение скрипта setup_linux.sh внутри контейнера:

bash /root/setup_linux.sh 0x<ваш_адрес>

Замените `<ваш_адрес>` на ваш реальный reward address.
