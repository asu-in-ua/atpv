[<- До підрозділу](README.md)

# Створення Open VPN для віддаленого налагодження об'єктів: практична частина

Ця лабораторна ще в розробці!





https://docs.netgate.com/pfsense/en/latest/recipes/openvpn-s2s-tls.html



**Тривалість**: 

**Мета:**  

## Лабораторна установка для проведення лабораторної роботи у віртуальному середовищі.

**Апаратне забезпечення, матеріали та інструменти для проведення віртуальної лабораторної роботи.** 



Рис.1.20. Функціональна схема лабораторної установки

**Програмне забезпечення, що використане у віртуальній лабораторній роботі.** 

1. Сніфер Wireshark (http://www.wireshark.org/)
2. 

## Загальна постановка задачі

Цілі роботи: 

- налаштувати віртуальну локальну мережу між хостовою та гостьовою ОС для проведення наступних лабораторних робіт
- 

## Послідовність виконання роботи

### 1. Створення центру сертифікації CA

завантажити

```
wget https://github.com/OpenVPN/easy-rsa/releases/download/v3.2.2/EasyRSA-3.2.2.tgz
```

розпакувати

```
tar -xzvf EasyRSA-3.2.2.tgz
```

виведе

```
EasyRSA-3.2.2/
EasyRSA-3.2.2/openssl-easyrsa.cnf
EasyRSA-3.2.2/._gpl-2.0.txt
tar: Ignoring unknown extended header keyword 'LIBARCHIVE.xattr.com.apple.metadata:kMDItemTextContentLanguage'
EasyRSA-3.2.2/gpl-2.0.txt
EasyRSA-3.2.2/ChangeLog
EasyRSA-3.2.2/x509-types/
EasyRSA-3.2.2/README.md
EasyRSA-3.2.2/COPYING.md
EasyRSA-3.2.2/easyrsa
EasyRSA-3.2.2/doc/
EasyRSA-3.2.2/vars.example
EasyRSA-3.2.2/README.quickstart.md
EasyRSA-3.2.2/doc/Intro-To-PKI.md
EasyRSA-3.2.2/doc/EasyRSA-Readme.md
EasyRSA-3.2.2/doc/EasyRSA-Contributing.md
EasyRSA-3.2.2/doc/Hacking.md
EasyRSA-3.2.2/doc/EasyRSA-Renew-and-Revoke.md
EasyRSA-3.2.2/doc/EasyRSA-Advanced.md
EasyRSA-3.2.2/doc/EasyRSA-Upgrade-Notes.md
EasyRSA-3.2.2/x509-types/ca
EasyRSA-3.2.2/x509-types/server
EasyRSA-3.2.2/x509-types/COMMON
EasyRSA-3.2.2/x509-types/kdc
EasyRSA-3.2.2/x509-types/code-signing
EasyRSA-3.2.2/x509-types/client
EasyRSA-3.2.2/x509-types/email
EasyRSA-3.2.2/x509-types/serverClient

```

![image-20250203101253415](C:\san\народн посібн атпв\gitver\nets\vpn\media\image-20250203101253415.png)

скопіювати в файл з назвою vars

відкрити файл vars, зняти комент (`#`) на set_var EASYRSA встановити наступний шлях

```
set_var EASYRSA	"/usr/local/etc/easy-rsa"
```

змінити також інші змінні

```
set_var EASYRSA_REQ_COUNTRY	"UA"
set_var EASYRSA_REQ_PROVINCE	"Kyiv"
set_var EASYRSA_REQ_CITY	"Kyiv"
set_var EASYRSA_REQ_ORG	"Copyleft Certificate Co"
set_var EASYRSA_REQ_EMAIL	"me@example.net"
set_var EASYRSA_REQ_OU		"My Organizational Unit"
```

зберегти файл `vars`

створити папку і скопіювати туди файли

```
cd EasyRSA-3.2.2
sudo mkdir -p /usr/local/etc/easy-rsa
sudo cp openssl-easyrsa.cnf /usr/local/etc/easy-rsa
sudo cp -r x509-types /usr/local/etc/easy-rsa/
```

ініціювати 

```
sudo ./easyrsa init-pki
```

має вивести

```
Using Easy-RSA 'vars' configuration:
* /home/osboxes/EasyRSA-3.2.2/vars

Notice
------
'init-pki' complete; you may now create a CA or requests.

Your newly created PKI dir is:
* /usr/local/etc/easy-rsa/pki

Using Easy-RSA configuration:
* /home/osboxes/EasyRSA-3.2.2/vars

```

побудувати кореневий сертифікат

```
sudo ./easyrsa build-ca
```

після того треба буде ввести секретну фразу і загальне імя. Запам'ятайте секретну фразу, вона потрібна буде пізніше для керування сертифікатами

```
Enter New CA Key Passphrase:
Confirm New CA Key Passphrase:
Common Name (eg: your user, host, or server name) [Easy-RSA CA]:
```

після чого з'явиться інформація 

```
CA creation complete. Your new CA certificate is at:
* /usr/local/etc/easy-rsa/pki/ca.crt
Create an OpenVPN TLS-AUTH|TLS-CRYPT-V1 key now: See 'help gen-tls'
Build-ca completed successfully.
```



подивитися сертифікат CA можна наступним чином

```
sudo openssl x509 -in /usr/local/etc/easy-rsa/pki/ca.crt -text -noout
```



### 2. Створення порожнього списку відкликаних сертифікатів

Створимо порожній список відкликаних сертифікатів

```
sudo ./easyrsa gen-crl
```

треба потім ввести секретну фразу

```
Using Easy-RSA 'vars' configuration:
* /home/osboxes/EasyRSA-3.2.2/vars
Using configuration from /usr/local/etc/easy-rsa/openssl-easyrsa.cnf
Enter pass phrase for /usr/local/etc/easy-rsa/pki/private/ca.key:

Notice
------
An updated CRL DER copy has been created:
* /usr/local/etc/easy-rsa/pki/crl.der

An updated CRL has been created:
* /usr/local/etc/easy-rsa/pki/crl.pem

IMPORTANT: When the CRL expires, an OpenVPN Server which uses a
CRL will reject ALL new connections, until the CRL is replaced.
```

потім ввести список відкликаних сертифікатів 

```
sudo openssl crl -noout -text -in /usr/local/etc/easy-rsa/pki/crl.pem
```

виведе щось таке

```
crl: Option -in needs a value
crl: Use -help for summary.
osboxes@osboxes:~/EasyRSA-3.2.2$ sudo openssl crl -noout -text -in /usr/local/etc/easy-rsa/pki/crl.pem
Certificate Revocation List (CRL):
        Version 2 (0x1)
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = servername
        Last Update: Feb  3 10:12:05 2025 GMT
        Next Update: Aug  2 10:12:05 2025 GMT
        CRL extensions:
            X509v3 Authority Key Identifier:
                keyid:AC:3A:32:1C:F7:47:BE:A7:8A:1E:FF:50:06:B5:CA:B8:24:6B:AE:E1
                DirName:/CN=servername
                serial:7A:65:D7:C8:A1:E4:6A:AF:19:0E:CA:57:41:B3:0D:7D:B0:D4:FB:B4

No Revoked Certificates.
    Signature Algorithm: sha256WithRSAEncryption
         c4:29:8a:60:a2:a3:5f:08:26:78:a7:24:16:34:16:b5:56:90:
         4d:84:59:a7:d7:74:f8:fc:5d:3e:8f:bd:93:d1:0d:8e:78:ea:
         b5:13:36:c3:b5:b5:01:1d:48:98:85:f2:cd:dd:6e:d0:5e:76:
         ee:79:67:4f:41:ab:43:45:47:69:93:cf:99:70:5a:9c:ad:77:
         e0:c9:91:53:4c:07:40:56:22:f9:b0:75:e4:6e:b4:d5:89:cc:
         38:7d:fe:60:d6:7d:75:16:12:17:5f:ad:de:d7:87:cd:6b:8d:
         0e:62:a5:94:08:37:6f:14:cb:0d:82:bb:b5:ad:4e:95:1e:73:
         90:33:be:c1:56:5c:86:8a:46:84:22:eb:84:41:08:79:85:78:
         7c:49:1b:a5:cc:00:72:66:cd:af:ce:8b:65:54:a8:e9:43:b0:
         75:10:44:33:f3:6a:0b:40:c9:47:5e:f3:23:7f:34:91:8a:0e:
         f3:c2:9a:07:e5:d6:bb:48:37:5d:e7:3d:a2:07:d2:26:89:4e:
         81:0d:2a:07:15:24:5f:9d:e1:39:20:95:3f:4c:70:30:41:c3:
         50:cd:e3:84:a3:1c:57:c6:3d:9b:36:ed:69:b6:2c:c9:15:28:
         e0:14:3f:61:11:82:99:0e:71:37:6b:a7:b0:28:1b:a4:ab:06:
         e2:78:fd:a2

```

### 3. Створення серверного сертифікату

створити і підписати серверний сертифікат для `movpn-server`

```
sudo ./easyrsa build-server-full movpn-server
```

Внизу виведений повний діалог:

- спочатку треба ввести PEM pass phrase і підтвердити її
- потім явно ввести yes, коли попросять
- потім задати секретну фразу для підписання сертифікату серверу

```
Using Easy-RSA 'vars' configuration:
* /home/osboxes/EasyRSA-3.2.2/vars
Generating a RSA private key
..................+++++
.........+++++
writing new private key to '/usr/local/etc/easy-rsa/pki/0c7cc353/temp.2.1'
Enter PEM pass phrase:
Verifying - Enter PEM pass phrase:
-----

Notice
------
Private-Key and Public-Certificate-Request files created.
Your files are:
* req: /usr/local/etc/easy-rsa/pki/reqs/movpn-server.req
* key: /usr/local/etc/easy-rsa/pki/private/movpn-server.key

You are about to sign the following certificate:

  Requested CN:     'movpn-server'
  Requested type:   'server'
  Valid for:        '825' days


subject=
    commonName                = movpn-server

Type the word 'yes' to continue, or any other input to abort.
  Confirm requested details: yes

Using configuration from /usr/local/etc/easy-rsa/pki/a8d357bf/temp.6.1
Enter pass phrase for /usr/local/etc/easy-rsa/pki/private/ca.key:
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'movpn-server'
Certificate is to be certified until May  9 10:34:41 2027 GMT (825 days)

Write out database with 1 new entries
Data Base Updated

Notice
------
Inline file created:
* /usr/local/etc/easy-rsa/pki/inline/private/movpn-server.inline


Notice
------
Certificate created at:
* /usr/local/etc/easy-rsa/pki/issued/movpn-server.crt
```

подивитися на сертифікат

```
sudo openssl x509 -noout -text -in /usr/local/etc/easy-rsa/pki/issued/movpn-server.crt
```

### 3. Створення серверного сертифікату для клієнтів

Створити і підписати серверний сертифікат для `remoteclient1`

```
sudo ./easyrsa build-client-full remoteclient1
```



Практичне заняття розробив  
