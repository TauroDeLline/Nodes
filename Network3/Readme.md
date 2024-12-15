# Установка ноды Network3

Для автоматической установки ноды выполните следующую команду:

```bash
wget -O Network3_Install https://raw.githubusercontent.com/TauroDeLline/Nodes/main/Network3/Network3_Install && chmod +x Network3_Install && ./Network3_Install
```

## Описание процесса

1. **Скачивание и установка зависимостей**
   Скрипт автоматически установит все необходимые пакеты, включая `wget`, `tar`, `screen`, и другие.

2. **Скачивание файлов ноды**
   Скрипт загрузит архив ноды `ubuntu-node-v2.1.0.tar`, распакует его и удалит исходный файл архива для экономии места.

3. **Запуск ноды**
   Нода запускается в новой `screen`-сессии для обеспечения её работы в фоне.

4. **Получение ключей API и ссылки**
   Скрипт автоматически считывает ключ API и ссылку из логов ноды и выводит их в консоль.

## Результат работы

После успешной установки скрипт выведет:

- **API Key**: Ключ API, необходимый для управления нодой.
- **Node Link**: Ссылка для доступа к ноде через браузер.

Пример вывода:

```
API Key: abcdef123456
Node Link: https://123.45.67.89:8080
```

## Логи

Для просмотра логов ноды в реальном времени выполните команду:

```bash
docker logs -f Network3
```

Чтобы выйти из просмотра логов, нажмите `Ctrl+C`. Нода продолжит работать в фоне.

## Подключение к контейнеру

Если необходимо подключиться к контейнеру ноды для выполнения дополнительных действий, выполните:

```bash
docker exec -it Network3 bash
```

В командной строке будет отображаться имя контейнера для удобства работы:

```
[node] /network3$
```
