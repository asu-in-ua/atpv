[<- До підрозділу](README.md)

# Telegraf: практична частина



https://www.influxdata.com/downloads/

- [ ] Запустіть пристрій або віртуальну машину з ОС Debian 

### 1. Встановлення Telegraf

https://docs.influxdata.com/telegraf/v1/install/?t=Older+than+Ubuntu+20.04

- [ ] Запустіть Putty та встановіть підключення до пристрою або віртуальної машини
- [ ] Встановіть з репозиторію Telegraf 

```
# influxdata-archive_compat.key GPG Fingerprint: 9D539D90D3328DC7D6C8D3B9D8FF8E1F7DF8B07E
curl --silent --location -O https://repos.influxdata.com/influxdata-archive_compat.key
gpg --show-keys --with-fingerprint --with-colons ./influxdata-archive_compat.key 2>&1 \
| grep -q '^fpr:\+9D539D90D3328DC7D6C8D3B9D8FF8E1F7DF8B07E:$' \
&& cat influxdata-archive_compat.key \
| gpg --dearmor \
| sudo tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' \
| sudo tee /etc/apt/sources.list.d/influxdata.list
sudo apt-get update && sudo apt-get install telegraf
```

### 2. Створення та редагування файлу конфігурації

- [ ] Перейдіть в домашню директорію

```
cd ~
```

- [ ] Сформуйте файл конфігурації з вказаними секціями. Для цього наберіть команду

```
telegraf config \
  --input-filter cpu:mem:disk \
  --output-filter mqtt \
  > telegraf.conf
```

- [ ] Використовуючи редактор, наприклад через WinSCP відредагуйте файл `telegraf.conf`, щоб там були такі параметри. Замість `firstname_lastanme` використовуйте комбінацію вашого імені та прізвища, наприклад `oleksandr_pupena`. 

```toml
[agent]
  interval = "10s"             					
  flush_interval = "10s"
  skip_processors_after_aggregators = true

[[inputs.cpu]]
  percpu = true
  totalcpu = true
  fieldinclude = ["usage_user", "usage_system", "usage_idle", "usage_iowait", "usage_steal"]

[[inputs.mem]]
  fieldinclude = ["total", "used", "free", "used_percent"]

[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "overlay"]
  fieldinclude = ["total","used","free","used_percent"]

[[outputs.mqtt]]
  servers = ["mqtt://test.mosquitto.org:1883"]
  topic = 'firstname_lastname/{{ .Tag "host" }}/{{ .Name }}/{{ .Tag "cpu" }}{{ .Tag "url" }}{{ .Tag "path" }}'
  data_format = "json"
```

### 3. Тестовий запуск

- [ ] Зробіть тестовий запуск, для цього введіть команду:

```
telegraf --config telegraf.conf --test
```

Тестовий запуск Telegraf (--test) — це режим одноразового збору метрик, який дозволяє перевірити, що конфігурація працює правильно і метрики дійсно збираються. Тестовий запуск не надсилає метрики у `outputs` (наприклад, в InfluxDB чи MQTT), не запускає фоновий агент і не показує помилки від плагінів виводу, натомість виводить зібрані метрики у stdout (термінал) у форматі line protocol

Має вийти щось на кшталт наступного:

```
osboxes@osboxes:~$ telegraf --config telegraf.conf --test
2025-08-08T07:52:10Z I! Loading config: telegraf.conf
2025-08-08T07:52:10Z I! Starting Telegraf 1.35.3 brought to you by InfluxData the makers of InfluxDB
2025-08-08T07:52:10Z I! Available plugins: 238 inputs, 9 aggregators, 34 processors, 26 parsers, 65 outputs, 6 secret-stores
2025-08-08T07:52:10Z I! Loaded inputs: cpu disk mem
2025-08-08T07:52:10Z I! Loaded aggregators:
2025-08-08T07:52:10Z I! Loaded processors:
2025-08-08T07:52:10Z I! Loaded secretstores:
2025-08-08T07:52:10Z W! Outputs are not used in testing mode!
2025-08-08T07:52:10Z I! Tags enabled: host=osboxes
> mem,host=osboxes free=3644260352u,total=4121886720u,used=194875392u,used_percent=4.7278201764846175 1754639531000000000
> disk,device=sda1,fstype=ext4,host=osboxes,mode=rw,path=/ free=216929148928u,total=232042008576u,used=3251159040u,used_percent=1.476589378043975 1754639531000000000
> disk,device=sda2,fstype=ext4,host=osboxes,mode=rw,path=/boot free=851435520u,total=965390336u,used=47161344u,used_percent=5.248331692375014 1754639531000000000
> disk,device=sda4,fstype=ext4,host=osboxes,mode=rw,path=/home free=269726162944u,total=284281606144u,used=40165376u,used_percent=0.014888950837613565 1754639531000000000
> cpu,cpu=cpu0,host=osboxes usage_idle=100,usage_iowait=0,usage_steal=0,usage_system=0,usage_user=0 1754639531000000000
> cpu,cpu=cpu1,host=osboxes usage_idle=98.07692307687935,usage_iowait=0,usage_steal=0,usage_system=1.923076923078631,usage_user=0 1754639531000000000
> cpu,cpu=cpu2,host=osboxes usage_idle=98.07692307688272,usage_iowait=0,usage_steal=0,usage_system=1.9230769230754383,usage_user=0 1754639531000000000
> cpu,cpu=cpu3,host=osboxes usage_idle=100,usage_iowait=0,usage_steal=0,usage_system=0,usage_user=0 1754639531000000000
> cpu,cpu=cpu-total,host=osboxes usage_idle=99.0243902438808,usage_iowait=0,usage_steal=0,usage_system=0.9756097560978865,usage_user=0 1754639531000000000
```

- [ ] Проаналізуйте отриманий результат

### 4. Запуск або перезапуск як служби

Telegraf за замовчуванням встановлюється як служба `systemd` на більшості сучасних дистрибутивів Linux (наприклад, Debian, Ubuntu, CentOS, Fedora), якщо ви використовуєте офіційні `.deb` або `.rpm` пакети від InfluxData або встановлюєте через `apt` / `yum` / `dnf`.  Після встановлення служба не запускається автоматично, поки ви самі не увімкнете або не запустите її.

- [ ] Зупиніть службу telegraf якщо вона запущена

```
sudo systemctl stop telegraf
```

- [ ] Перезапишіть стандартний конфігураційний файл, у більшості дистрибутивів Telegraf за замовчуванням використовує файл `/etc/telegraf/telegraf.conf`, щоб його перезаписати, виконайте:

```
sudo cp ./telegraf.conf /etc/telegraf/telegraf.conf
```

- [ ] Перевірити, що файл успішно оновлено, наприклад вивівши тільки значення параметрів `servers`

```
cat /etc/telegraf/telegraf.conf | grep servers
```

має вивести відповідний рядок

- [ ] Запустіть службу Telegraf з новою конфігурацією

```
sudo systemctl start telegraf
```

- [ ] Перевірте що служба працює

```
sudo systemctl status telegraf
```

### 5. Тестування отримання через MQTT Explorer

- [ ] Запустіть MQTT Explorer. Вкажіть брокер та тему `firstname_lastname/#`. 
- [ ] Подивіться на отримані результати

### 6. Збір метрик за допомогою `[[inputs.ping]]`

- [ ] Використовуючи редактор, наприклад через WinSCP добавте у файл  `telegraf.conf` секцію для тестування доступності мережних вузлів, щоб там були такі параметри.

```toml
[[inputs.ping]]
  ## Список хостів або IP-адрес для пінгу
  urls = ["192.168.1.1", "8.8.8.8"]
  ## Метод пінгу: "exec" (через системну утиліту ping) або "native" (через ICMP напряму)
  ## Рекомендується "native", якщо є права (CAP_NET_RAW або root)
  method = "native"
  ## Кількість пінгів за кожен інтервал збирання
  count = 4
  ## Інтервал між пінгами в секундах
  ping_interval = 1.0
  ## Час очікування відповіді
  timeout = 1.0
  ## Загальний дедлайн для пінгів
  deadline = 5
  ## Відсоток втрачених пакетів
  fieldinclude = ["percent_packet_loss", "maximum_response_ms"]
```

- [ ] Запустіть telegraf для тесту

```
sudo telegraf --config telegraf.conf --test
```

Має з`явитися додаткова інформація про результат пінгу, щось на кшталт

```
> ping,host=osboxes,url=8.8.8.8 maximum_response_ms=31.362648,percent_packet_loss=0 1754652895000000000
> ping,host=osboxes,url=192.168.1.1 percent_packet_loss=100 1754652897000000000
```

Як бачимо у цьому випадку відсоток втрачених пакетів для  8.8.8.8 = 0, а для  192.168.1.1 - 100%.

### 7.Переналаштування та перезапуск служби

- [ ] Перезапишіть стандартний конфігураційний файл:

```
sudo cp ./telegraf.conf /etc/telegraf/telegraf.conf
```

- [ ] Запустіть редактор для зміни налаштувань служби 

```
sudo systemctl edit telegraf
```

- [ ] Вставте зміст нижче між рядків коментарю, після чого збережіть `CTRL+X`, `Y`

```toml
### Anything between here and the comment below will become the new contents of the file

[Service]
CapabilityBoundingSet=CAP_NET_RAW
AmbientCapabilities=CAP_NET_RAW

### Lines below this comment will be discarded
```

- [ ] Перезапустіть службу telegraf

```
sudo systemctl restart telegraf
```





## Додаткові пункти для Raspberry PI5







Практичне заняття розробив  
