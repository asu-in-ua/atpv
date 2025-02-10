[<- До підрозділу](README.md) [Теорія по OpenVPN](openvpn.md)

# Встановлення та налаштування OpenVPN на Debian

https://wiki.debian.org/OpenVPN

## Загальні поняття

# Встановлення

Встановіть пакет *openvpn* як на клієнті, так і на сервері.

```
sudo apt update
sudo apt-get install openvpn
```

Щоб увімкнути OpenVPN в аплеті Gnome [NetworkManager](https://wiki.debian.org/NetworkManager) для області сповіщень на панелі завдань, на клієнті потрібно встановити додатковий пакет *network-manager-openvpn-gnome*:

```
apt-get install network-manager-openvpn-gnome
```



# Попередні умови

На брандмауері сервера відкрийте UDP 1194 (порт за замовчуванням). Майте на увазі, що 90% усіх проблем підключення, з якими стикаються нові користувачі OpenVPN, пов’язані з брандмауером. Дізнатися чи використовується брандмауер iptables на пристрої:

```
sudo iptables -L
```

Додайте правило для відкриття порту udp для вхідного трафіку:

```
sudo iptables -A INPUT -p udp --dport 1194 -j ACCEPT
```

Збережіть правила

```
sudo apt install iptables-persistent
sudo netfilter-persistent save
```

Перевірка чи порт слухають всередині сервера після запуску 

```
sudo netstat -tuln | grep 1194
або
sudo ss -tuln | grep 1194
```

Якщо порожньо то порт не прослуховується. Перевірка відкритості порту ззовні через утиліту nmap: 

```
nmap -sU -p 1194 -T4 1.1.1.1
```

# Конфігурування

OpenVPN може автентифікувати користувачів за допомогою user/pass, попереднього спільного ключа, сертифікатів тощо.

## Системне меню NetworkManager / GNOME

Можна повністю налаштувати з’єднання OpenVPN за допомогою параметрів Debian GNOME за замовчуванням разом із `network-manager-openvpn-gnome`. Підключенням VPN керуватиметься, як і будь-яким іншим мережевим підключенням, у [NetworkManager](https://wiki.debian.org/NetworkManager), а також матиме елементи керування в системному меню GNOME поруч із елементами керування [WiFi](https://wiki.debian.org/WiFi) та Ethernet. Щоб певне мережеве підключення автоматично активувало конфігурацію OpenVPN у GNOME 42 (використовується в bookworm), використовуйте `nm-connection-editor`. Знайдіть мережеве підключення, відкрийте його налаштування, а потім у розділі *Загальні* увімкніть *Автоматично підключатися до VPN.* Після збереження рядок `secondaries=` додається до файлу конфігурації цієї мережі в розділі `[підключення]`. Він міститиме список UUID вторинного підключення, які потрібно активувати. Зазвичай файл конфігурації */etc/NetworkManager/system-connections/*.

## Сире (незахищене) VPN з'єднання для тестування

### Серверна частина

Якщо ваш клієнт має статичний IP з оболонки сервера запустіть

```
# openvpn --remote CLIENT_IP --dev tun1 --ifconfig 10.9.8.1 10.9.8.2
```

Якщо ваш клієнт має динамічний IP запустіть

```
sudo openvpn --dev tun1 --ifconfig 10.9.8.1 10.9.8.2
```

Ви повинні побачити консольний вихід, схожий на

```
2021-09-03 21:22:18 library versions: OpenSSL 1.1.1k  25 Mar 2021, LZO 2.10
2021-09-03 21:22:18 ******* WARNING *******: All encryption and authentication features disabled -- All data will be tunnelled as clear text and will not be protected against man-in-the-middle changes. PLEASE DO RECONSIDER THIS CONFIGURATION!
2021-09-03 21:22:18 TUN/TAP device tun1 opened
...
```

Під час роботи `openvpn` перевірте конфігурацію мережі за допомогою `ip a`. Вихідні дані повинні включати

```
9: tun1: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UNKNOWN group default qlen 500
    link/none
    inet 10.9.8.1 peer 10.9.8.2/32 scope global tun1
       valid_lft forever preferred_lft forever
    inet6 fe80::dc71:3707:693c:5017/64 scope link stable-privacy
       valid_lft forever preferred_lft forever
```

Зауважте, що якщо ви закриєте `openvpn` (наприклад, за допомогою Control-c у його консолі), ви не побачите наведений вище мережний інтерфейс.

### Client part

```
# openvpn --remote SERVER_IP --dev tun1 --ifconfig 10.9.8.2 10.9.8.1
...
2021-09-03 21:32:32 Peer Connection Initiated with [AF_INET]SERVER_IP:PORT
2021-09-03 21:32:32 2012 WARNING: this configuration may cache passwords in memory -- use the auth-nocache option to prevent this
2021-09-03 21:32:32 Initialization Sequence Completed
...
```

Ви також можете зробити *ping* сервера, щоб перевірити його доступність: `ping 10.9.8.1`.

## VPN-з'єднання зі статичним ключем

### Конфігурація VPN-сервера зі статичним ключем

У каталозі `/etc/openvpn` сервера виконайте таку команду, щоб створити статичний ключ:

```
# openvpn --genkey secret static.key
```

Примітка: для OpenVPN 2.4 на Debian 10 використовуйте `--secret` замість `secret`. Скопіюйте цей статичний ключ до каталогу клієнта `/etc/openvpn` за допомогою безпечного каналу, наприклад `scp` або `sftp`. На сервері створіть новий файл `/etc/openvpn/tun0.conf` і додайте наступне:

```
dev tun0
ifconfig 10.9.8.1 10.9.8.2
secret /etc/openvpn/static.key
```

Де `10.9.8.x` — ваша підмережа VPN, `10.9.8.1` — IP-адреса сервера, `10.9.8.2` — IP-адреса клієнта.

### Конфігурація VPN-клієнта зі статичним ключем

На клієнті скопіюйте `/etc/openvpn/static.key` із сервера та створіть новий файл `/etc/openvpn/tun0.conf` і додайте таке:

```
remote your-server.org
dev tun0
ifconfig 10.9.8.2 10.9.8.1
secret /etc/openvpn/static.key
```

Запустіть OpenVPN вручну з обох сторін за допомогою такої команди (докладне виведення на 6):

```
# openvpn --config /etc/openvpn/tun0.conf --verb 6
```

Щоб переконатися, що VPN працює, ви повинні мати можливість перевірити `10.9.8.2` на сервері та `10.9.8.1` на клієнті.

## VPN-з'єднання з підтримкою TLS

Починаючи з Jessie, easy-rsa — це окремий пакет, який слід завантажувати разом із встановленням openvpn.

### Ініціалізація easy-rsa

```
# cd /etc/openvpn
# make-cadir easy-rsa/
```

Щоб ініціалізувати середовище, просто скористайтеся такою командою:

```
cd easy-rsa/
./easyrsa init-pki
```

Усі команди запускаються з папки easy-rsa. Зверніться до `./easyrsa help` для детального опису доступних команд.

Пам'ятайте:

- тільки файли `.key` повинні бути конфіденційними.
- Файли `.crt` і `.csr` можна надсилати через незахищені канали, такі як звичайна електронна пошта.
- не потрібно копіювати файл `.key` між комп'ютерами.
- кожен комп'ютер матиме власний сертифікат/пару ключів.

### Створення CA CERTIFICATE/KEY

Створіть CERTIFICATE/KEY ЦЕНТРУ СЕРТИФІКАЦІЇ (CA):

```
# ./easyrsa build-ca
```

Він створить `ca.crt` і `ca.key` в каталогах `/etc/openvpn/easy-rsa/{pki,pki/private}`. Згенеруйте CERTIFICATE/KEY сервера:

```
# ./easyrsa build-server-full server
```

Він створить `server.crt` і `server.key` у `/etc/openvpn/easy-rsa/pki/{issued/server.crt,private/server.key}` і підпише ваш кореневий сертифікат.

### Створення DIFFIE-HELLMAN PARAMETERS

Створіть *BUILD DIFFIE-HELLMAN PARAMETERS* (необхідно для серверної сторони підключення SSL/TLS):

```
./easyrsa gen-dh
```

### Створення Static Key для TLS authentication

Якщо ви вже створили статичний ключ, ви можете перейменувати його на `ta.key` і перемістити до папки `/etc/openvpn/server`. Інакше виконайте наступне:

```
openvpn --genkey secret /etc/openvpn/server/ta.key
```

Примітка. Для OpenVPN 2.4 on Debian 10, вкиористовуйте `--secret` замість `secret`. 

### Створення CERTIFICATE/KEYs для клієнтів 

Створіть ключ для кожного **клієнта**: скористайтеся однією з наступних двох команд.

- Згенеруйте ключ без пароля: 

```
./easyrsa build-client-full clientname nopass
```

- Згенерувати ключ із паролем: вам буде запропоновано ввести "Enter PEM pass phrase" (це парольна фраза, яку вам знадобиться для входу в клієнт кожного разу, коли ви підключаєтесь до сервера), для кожного **клієнта**:

```
./easyrsa build-client-full clientname
```

Він створить ключі в `/etc/openvpn/easy-rsa/pki/{issued/clientname.crt,private/clientname.key}`.

### Встановлення Client CERTIFICATE/KEYs

Скопіюйте `ca.crt, clientname.crt, clientname.key` з каталогів Server до Client `/etc/openvpn/easy-rsa/pki/{issued/clientname.crt,private/clientname.key}`.

Перевірте [ключ OpenVPN RSA](http://openvpn.net/index.php/open-source/documentation/miscellaneous/77-rsa-key-management.html), щоб дізнатися більше.

### VPN підключення через командний рядок 

Server: 

```
openvpn --dev tun1 --ifconfig 10.9.8.1 10.9.8.2 --tls-server --dh /etc/openvpn/easy-rsa/pki/dh.pem --ca /etc/openvpn/easy-rsa/pki/ca.crt --cert /etc/openvpn/easy-rsa/pki/issued/server.crt --key /etc/openvpn/easy-rsa/pki/private/server.key --reneg-sec 60 --verb 5 --cipher AES-256-CBC --auth SHA512 --tls-version-min 1.3 --auth-nocache
```

Client: 

```
openvpn --remote SERVER_IP --dev tun1 --redirect-gateway def1 --ifconfig 10.9.8.2 10.9.8.1 --tls-client --ca /etc/openvpn/easy-rsa/pki/ca.crt --cert /etc/openvpn/easy-rsa/pki/issued/clientname.crt --key /etc/openvpn/easy-rsa/pki/private/clientname.key --reneg-sec 60 --verb 5 --cipher AES-256-CBC --auth SHA512 --tls-version-min 1.3 --auth-nocache
```

### Конфігураційний файл VPN Server 

Якщо попереднє підключення успішне, створіть файл конфігурації сервера `/etc/openvpn/server.conf` таким чином:

```
port 1194
proto udp
dev tun

ca      /etc/openvpn/easy-rsa/pki/ca.crt
cert    /etc/openvpn/easy-rsa/pki/issued/server.crt
key     /etc/openvpn/easy-rsa/pki/private/server.key  # keep secret
dh      /etc/openvpn/easy-rsa/pki/dh.pem

topology subnet

server 10.9.8.0 255.255.255.0  # internal tun0 connection IP
ifconfig-pool-persist ipp.txt

push "route 192.168.0.0 255.255.255.0"
push "redirect-gateway def1 bypass-dhcp"

keepalive 10 120

tls-auth /etc/openvpn/server/ta.key 0
auth-nocache

cipher AES-256-CBC
data-ciphers AES-256-CBC

persist-key
persist-tun

status /var/log/openvpn/openvpn-status.log

verb 3  # verbose mode

client-to-client
explicit-exit-notify 1
```

Створити файл статусу журналу:

```
# touch /var/log/openvpn/openvpn-status.log
```

Перезапуск OpenVPN. 

```
# service openvpn restart
```

Зауважте, що сценарій `/etc/init.d/openvpn`, запущений `service openvpn restart`, запустить сервер openvpn для кожного файлу `.conf` у `/etc/openvpn/`, тому, якщо у вас все ще є файл `tun0.conf`, перейменуйте його на щось інше, ніж `*.conf`. Це тому, що systemd за замовчуванням хоче лише один сервер openvpn.

### Конфігураційний файл VPN Client

У клієнті створіть `/etc/openvpn/client.conf` таким чином: (примітка: ви можете використовувати графічний інтерфейс мережевого менеджера vpn, надавши ключ і сертифікати)

```
client
dev tun
proto udp

remote VPNSERVER_IP 1194             # [VPN server IP] [PORT]
resolv-retry infinite
nobind

persist-key
persist-tun

ca      /etc/openvpn/easy-rsa/pki/ca.crt
cert    /etc/openvpn/easy-rsa/pki/issued/clientname.crt
key     /etc/openvpn/easy-rsa/pki/private/clientname.key

remote-cert-tls server
tls-auth /etc/openvpn/server/ta.key 1
auth-nocache

cipher AES-256-CBC
data-ciphers AES-256-CBC

mute-replay-warnings

verb 3
```

Restart OpenVPN: 

```
# service openvpn restart
```

## Запуск VPN підключення як Systemd service

### At the root of /etc/openvpn/

За замовчуванням усі налаштовані VPN у `/etc/openvpn/` запускаються під час завантаження системи. Відредагуйте `/etc/default/openvpn`, щоб запустити певні VPN або вимкнути цю поведінку. Вам потрібно один раз запустити `systemctl daemon-reload`, щоб увімкнути нові VPN

### у вкладених папках server і client

У Debian служба systemd очікує, що файли конфігурації сервера та клієнта будуть відповідно у `/etc/openvpn/server` та `/etc/openvpn/client`. Після того як ви створили конфігураційний файл у правильній папці, його потрібно ввімкнути. Наприклад, припустімо, що ви створили конфігурацію в `/etc/openvpn/server/myserver.conf`:

```
systemctl start openvpn-server@myserver
systemctl enable openvpn-server@myserver
```

## Запуск VPN підключення через файли інтерфейсів

openvpn [ifupdown](https://packages.debian.org/ifupdown) також доступні для запуску/зупинки тунелів за допомогою `/etc/network/interfaces`, наприклад:

```
auto dsl
iface dsl inet ppp
    provider dsl-provider
    openvpn work_vpn
```

Див `/usr/share/doc/openvpn/README.Debian.gz` для детальної інформації 

## Android / iOS devices certificate generation

...

# Forward traffic to provide access to the Internet

## on the Server

In Server enable runtime IP forwarding: 

```
echo 1 > /proc/sys/net/ipv4/ip_forward
```

Edit */etc/sysctl.conf* uncomment the following line to make it permanent: 

```
net.ipv4.ip_forward = 1
```

Execute the following command in server for testing (Old way): 

```
IF_MAIN=eth0
IF_TUNNEL=tun0
YOUR_OPENVPN_SUBNET=10.9.8.0/24
#YOUR_OPENVPN_SUBNET=10.8.0.0/16 # if using server.conf from sample-server-config
iptables -A FORWARD -i $IF_MAIN -o $IF_TUNNEL -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -s $YOUR_OPENVPN_SUBNET -o $IF_MAIN -j ACCEPT
iptables -t nat -A POSTROUTING -s $YOUR_OPENVPN_SUBNET -o $IF_MAIN -j MASQUERADE
```

Execute the following command in server for testing (Starting with Bullseye): 

```
IF_MAIN=eth0
IF_TUNNEL=tun0
YOUR_OPENVPN_SUBNET=10.9.8.0/24
#YOUR_OPENVPN_SUBNET=10.8.0.0/16 # if using server.conf from sample-server-config

nft add table ip filter
nft add table ip nat
nft add chain ip filter FORWARD
nft add chain nat POSTROUTING '{ type nat hook postrouting priority srcnat; policy accept; }'
nft add rule ip filter FORWARD iifname "$IF_MAIN" oifname "$IF_TUNNEL" ct state related,established accept
nft add rule ip filter FORWARD oifname "$IF_MAIN" ip saddr $YOUR_OPENVPN_SUBNET accept
nft add rule ip nat POSTROUTING oifname "$IF_MAIN" ip saddr $YOUR_OPENVPN_SUBNET masquerade
```

You may also use the *rc.firewall-iptables* script from [TLDP Masquerade](http://tldp.org/HOWTO/IP-Masquerade-HOWTO/firewall-examples.html#RC.FIREWALL-IPTABLES) as an alternative. 

If everything is working fine, save the rules: Debian wiki [iptables](https://wiki.debian.org/iptables) and [nftables](https://wiki.debian.org/nftables) pages for details. 

# Manage the Public Key Infrastructure

[?](https://wiki.debian.org/EasyRSA)easy-rsa helps to manage the key of your PKI: 

- Generation of client & server certificates 
- revocaton of certificates 

More info here: /usr/share/doc/easy-rsa/doc 

For security purpose, it is advised to set up the PKI in a different server that the openvpn server. 

# Application to a VPN passing through a http proxy

**Prerequisites**: [install an HTTP proxy](https://www.debian.org/doc/manuals/debian-handbook/sect.http-ftp-proxy.en.html) 

This part describe how to configure a VPN to pass through a http proxy,  which allow only trafic on port 443 (and 80). This use the http-proxy  option of OpenVPN. 

1. First of all, check that the port 443 isn't already used by another service on your server. 
2. Configure OpenVPN on server side by adding *port 443* and *proto tcp-server* to the configuration file. This option works only with TCP as the tunnel carrier protocol 
3. Configure OpenVPN on the client side by adding *port 443*, *proto tcp-client* and *http-proxy 1.1.1.1 8080* to the configuration file. 

Where 1.1.1.1 and 8080 are IP and port of your proxy. 

1. Now you should launch OpenVPN on the server and next on the client. 

# Enable and use the Management Interface

Enable the option in server conf file by adding: 

```
management localhost 7505
```

Connect to this interface: 

```
telnet localhost 7505
```

This is useful for authentication (http-proxy) or killing an open session. [More info](https://openvpn.net/community-resources/management-interface/) 

# Troubleshooting

- Check the log files which are by default in /var/log/openvpn/ 
- Most of VPN issue are related to firewall configuration 
- Check if it might be related to natwork routing table on server (or client) side 
- Another lead: DNS management (resolv.conf, resovlconf) on both server and client side 



Адаптовано [Олександр Пупена](https://github.com/pupenasan). 