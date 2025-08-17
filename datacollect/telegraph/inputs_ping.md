[<- До підрозділу](README.md)

# Плагін inputs.ping

https://github.com/influxdata/telegraf/blob/release-1.35/plugins/inputs/ping/README.md

Цей плагін збирає метрики про пакети ICMP ping, включно з часом затримки в обидві сторони (round-trip time), часом відповіді та іншими статистичними показниками пакетів. Якщо використовується метод `exec`, команда `ping` повинна бути доступна в системі та мати права на виконання від імені Telegraf.

Версія: з Telegraf v0.1.8
Категорія: network
Сумісність: всі платформи

## Глобальні параметри конфігурації

Окрім специфічних налаштувань плагіна, підтримуються й глобальні параметри конфігурації. Вони дозволяють змінювати метрики, теги, поля, створювати псевдоніми тощо. Детальніше дивись у файлі `CONFIGURATION.md`.

```toml
# Пінг обраних хостів та повернення статистики
[[inputs.ping]]
  ## Хости, до яких надсилати ping
  urls = ["example.org"]

  ## Метод надсилання ping: "exec" або "native"
  # method = "exec"

  ## Кількість пакетів на інтервал
  # count = 1

  ## Інтервал між пакетами в секундах
  # ping_interval = 1.0

  ## Таймаут очікування відповіді
  # timeout = 1.0

  ## Загальний дедлайн для всіх пакетів
  # deadline = 10

  ## Мережевий інтерфейс або IP-адреса джерела
  # interface = ""

  ## Відсоткові значення для розрахунку (лише для native)
  # percentiles = [50, 95, 99]

  ## Виконуваний файл ping
  # binary = "ping"

  ## Аргументи для ping. Якщо встановлено, ігноруються інші параметри
  # arguments = ["-c", "3"]

  ## Використовувати лише IPv4
  # ipv4 = false

  ## Використовувати лише IPv6
  # ipv6 = false

  ## Розмір пакета в байтах (лише для native)
  # size = 56
```

## Методи виконання

Плагін підтримує два методи:

- `exec`: викликає системну утиліту `ping`. За замовчуванням.
- `native`: надсилає ICMP-пакети напряму в Go, без зовнішніх залежностей. Рекомендовано.

Для `exec`: Потрібна утиліта `ping`. На Debian краще використовувати `iputils-ping`:

```bash
sudo apt install iputils-ping
```

Для `native`: Потрібні привілеї на `CAP_NET_RAW` або запуск від `root`. Для systemd:

```ini
# systemctl edit telegraf

[Service]
CapabilityBoundingSet=CAP_NET_RAW
AmbientCapabilities=CAP_NET_RAW
```

Потім:

```bash
sudo systemctl restart telegraf
```

Або без systemd:

```bash
sudo setcap cap_net_raw=eip /usr/bin/telegraf
```

## Ліміт відкритих файлів

Плагін може відкривати багато файлів при ping великої кількості хостів. Щоб уникнути помилок типу "too many open files", можна збільшити обмеження:

```ini
# systemctl edit telegraf

[Service]
LimitNOFILE=8192
```

Потім:

```bash
sudo systemctl restart telegraf
```

## Метрики

Метрика: `ping`
Теги:

- `url`

Поля:

- `packets_transmitted` (integer)
- `packets_received` (integer)
- `percent_packet_loss` (float)
- `ttl` (integer, недоступний на Windows)
- `average_response_ms` (float)
- `minimum_response_ms` (float)
- `maximum_response_ms` (float)
- `standard_deviation_ms` (float, лише Windows і method = "native")
- `percentile<N>_ms` (float, лише native)
- `errors` (float, лише Windows)
- `reply_received` (Windows, method = "exec")
- `percent_reply_loss` (Windows, method = "exec")
- `result_code` (0 = success, 1 = no such host, 2 = ping error)

### Приклад виводу

```
ping,url=example.org average_response_ms=23.066,ttl=63,maximum_response_ms=24.64,minimum_response_ms=22.451,packets_received=5i,packets_transmitted=5i,percent_packet_loss=0,result_code=0i,standard_deviation_ms=0.809 1535747258000000000
```

