
Задание 2. Шардирование

1. Создание контейнеров

docker compose -f compose.yaml up

2. Настройка шардирования

Запустить скрипт ./config-check.sh
Скрипт:
- инициализирует шардирование
- создаст тестовые данные
- запросит подсчет записей в шардах

3. Замечено

Если повторно создавать контейнеры, может возникнуть ошибка вида:
MongoServerError[AlreadyInitialized]: already initialized

Перед повтором п. 1 удалить вольюмы:
docker volume rm $(docker volume ls -q)
