Start - обновляет систему, устанавливает докер с легким базовым образом, устанавливает node-exporter для дальнейшей настрйоки мониторинга

``` bash
wget --no-cache -q -O Start.sh https://raw.githubusercontent.com/TauroDeLline/Nodes/main/Setup%20server/Start && chmod +x Start.sh && ./Start.sh
```

Base Container - запрашивает название и создает докер-контейнер с 22 убунтой

``` bash
curl -fsSL https://raw.githubusercontent.com/TauroDeLline/Nodes/main/Setup%20server/Base_Container -o Base_Container && chmod +x Base_Container && ./Base_Container
```
Создаем все необходимые папки

``` bash
mkdir Cysic Elixir Hemi Multiple Network3 Nexus Ocean_Nodes Rivalz
```
