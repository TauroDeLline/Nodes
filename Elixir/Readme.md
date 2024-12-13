Есть и майннет, и тестнет. Нет смысла ставить тест, только майннет
Майннет - ```elixir.xyz/validators```


# Скачивание, разрешение и запуск:

`wget -O Elixir_Install https://raw.githubusercontent.com/TauroDeLline/Nodes/main/Elixir/Elixir_Install && chmod +x Elixir_Install && ./Elixir_Install`

# Elixir Validator - Инструкция

## Запуск ноды:

```docker run -d --env-file validator.env --name elixir --restart unless-stopped elixirprotocol/validator:latest```

## Проверка логов с хоста: 

```docker logs -f elixir```
Нажмите `Ctrl+C` для выхода из просмотра логов (нода продолжит работать).

## Вход в контейнер:

```docker exec -it elixir bash```

## Перезапуск контейнера при сбоях и рестартах сервера:

Опция `--restart unless-stopped` гарантирует, что контейнер автоматически запустится при перезагрузке сервера или если валидатор выйдет из строя.

## Обновление валидатора:

Когда выйдет новая версия валидатора:
```
docker kill elixir
docker rm elixir
docker pull elixirprotocol/validator:latest
```
И снова запустить контейнер

```docker run -d --env-file validator.env --name elixir --restart unless-stopped elixirprotocol/validator:latest```
