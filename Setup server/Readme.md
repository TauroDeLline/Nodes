Start - обновляет систему, устанавливает докер с легким базовым образом, устанавливает node-exporter для дальнейшей настрйоки мониторинга

``` bash
curl -fsSL https://raw.githubusercontent.com/TauroDeLline/Nodes/main/Setup%20server/Start -o Start && chmod +x Start && ./Start
```

Base Container - запрашивает название и создает докер-контейнер с 22 убунтой

``` bash
curl -fsSL https://raw.githubusercontent.com/TauroDeLline/Nodes/main/Setup%20server/Base_Container -o Base_Container && chmod +x Base_Container && ./Base_Container
```
