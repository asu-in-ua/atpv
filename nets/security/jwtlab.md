[<- До підрозділу](README.md) 			[Коментувати](#feedback)

# JSON Web Tokens : практичне заняття

**Тривалість**: 2 акад. години (1 пара).

**Мета:** ознайомлення з основними можливостями роботи з JSON Web Tokens з використанням бібліотеки `jsonwebtoken` та Node-RED.  

**Лабораторна установка**

- Апаратне забезпечення: ПК, Інтернет. 
- Програмне забезпечення: Node-RED.

## Порядок виконання роботи 

### Пре-реквізити

Для лабораторної роботи необхідно мати встановлений Node-RED, та мінімальні знання його використання.

- [ ] Якщо у Вас не встановлено Node-RED, пройдіть практичне заняття [Вступ до Node-RED: практичне заняття](../../nodered/intro/lab.md)

### 1. Знайомство з теорією 

- [ ] Прочитайте основні теоретичні відомості використання JSON Web Tokens [JSON Web Tokens : теоретична частина](jwt.md) (достатньо перший пункт - теоретичні відомості) 
- [ ] Ознайомтеся з [JSON Web Tokens в JS : теоретична частина](jwtjs.md)

###  2. Знайомство з сервісами jwt.io в режимі JWT Encoder

- [ ] Перейдіть на сайт <https://www.jwt.io/#debugger-io>
- [ ] Ознайомтеся з інтерфейсом в режимі JWT Encoder (формування JWT токена)
- [ ] Зверніть увагу на структуру веб-токена, з яких частин він складається? 
- [ ] Яке кодування використовується для токена?
- [ ] Дізнайтеся з теоретичних відомостей яка з частин токена є дійсно зашифрованою? Для чого це робиться? 
- [ ] Які твердження Ви бачите в Payload? Чи є вони зареєстрованими в  [IANA JSON Web Token Registry](https://www.iana.org/assignments/jwt/jwt.xhtml) і якщо є то що вони значать? 
- [ ] У полі Generate Example виберіть алгоритм шифрування `RS256`.
- [ ] Змініть поле  `name` на ваше прізвище та ім'я.
- [ ] Добавте поле `exp` зі значенням на один більше ніж `iat` 
- [ ] Скопіюйте згенерований токен, і збережіть в текстовий файл, він знадобиться
- [ ] Скопіюйте приватний ключ, і збережіть в текстовий файл, він знадобиться  

###  3. Знайомство з сервісами jwt.io в режимі JWT Decoder

- [ ] Перемкніться в режим JWT Decoder (отримання даних з JWT токена) 
- [ ] Скопіюйте публічний ключ в окремий файл, він знадобиться у майбутньому
- [ ] Вставте скопійований токен в поле `Encoded value` 
- [ ] Перевірте що декодовані поля співпадають і JWT валідний і підпис верифіковано.
- [ ] Наведіть вказівник миші на дату та час видачі та терміну дії токена (рис.1). Зверніть увагу на значення.

- [ ] Змініть останню літеру в токені, яка реакція? 

![image-20251211003428736](media/image-20251211003428736.png)

рис.1. Визначення дати та часу видачі та терміну дії 

### 4. Декодування в Node-RED

#### 4.1. Імпорт потоку

- [ ] Запустіть Node-RED
- [ ] Імпортуйте потік, скопіювавши його в буфер з наведеного нижче коду

```json
[{"id":"b3ceb6dba19a60cd","type":"group","z":"d9e2b117923ec466","name":"декодування та верифікація JWT","style":{"label":true},"nodes":["e5e50d62832729a3","76148fbc82ea4f61","fbb456c380555c21","be28e858285bd357","f010d33f62711025"],"x":64,"y":399,"w":632,"h":82},{"id":"e5e50d62832729a3","type":"function","z":"d9e2b117923ec466","g":"b3ceb6dba19a60cd","name":"from jwt","func":"try {\n  //якщо немає помилки то вивести результа\n  msg.payload = jsonwebtoken.verify(\n    msg.jwt, msg.public_key, { algorithms: ['RS256'] });\n} catch(err) {\n  //якщо є помилка то вивести причиниу\n  msg.err = err; \n}\nreturn msg;","outputs":1,"timeout":0,"noerr":0,"initialize":"","finalize":"","libs":[{"var":"jsonwebtoken","module":"jsonwebtoken"}],"x":540,"y":440,"wires":[["f010d33f62711025"]]},{"id":"76148fbc82ea4f61","type":"template","z":"d9e2b117923ec466","g":"b3ceb6dba19a60cd","name":"jwt","field":"jwt","fieldType":"msg","format":"text","syntax":"plain","template":"eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ik9sZWtzYW5kciBQdXBlbmEiLCJhZG1pbiI6dHJ1ZSwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE1MTYyMzkwMjJ9.SIzI8ai6WR-KsNTYUDyNgkMvO5xCS9giEHXwVX4ifU-2GrFuinZKPL1FMZCE8v1FXiB87RbZ3Az7spGRYt1rt8SQFXuKtmY6dAeNo5j7VfnCkhXzXHRfAJJZ6EbAOMTRSL4s7F7bJLdkYt6i5fVADUK6Deo_r-0X8Yt-slEtPCBGwyg4bpauxN1-mAnlfS-axKkxRoaCZ-2Uhhhqoc3DsShaEC3PjV3tyLjiPTCNWy8gxi7xxynU17Le5dCVxcIUoS8eirYQZJQq3p9ELMZXXBhmV3IBhxfrJGWJqRP-x9mt6ufHfL0N64gyfIUGOMRuvmCDbUxC3ijU822fRquZFg","output":"str","x":230,"y":440,"wires":[["be28e858285bd357"]]},{"id":"fbb456c380555c21","type":"inject","z":"d9e2b117923ec466","g":"b3ceb6dba19a60cd","name":"","props":[{"p":"now","v":"","vt":"date"},{"p":"topic","vt":"str"}],"repeat":"","crontab":"","once":false,"onceDelay":0.1,"topic":"","x":125,"y":440,"wires":[["76148fbc82ea4f61"]],"l":false},{"id":"be28e858285bd357","type":"template","z":"d9e2b117923ec466","g":"b3ceb6dba19a60cd","name":"public pem","field":"public_key","fieldType":"msg","format":"text","syntax":"plain","template":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu1SU1LfVLPHCozMxH2Mo\n4lgOEePzNm0tRgeLezV6ffAt0gunVTLw7onLRnrq0/IzW7yWR7QkrmBL7jTKEn5u\n+qKhbwKfBstIs+bMY2Zkp18gnTxKLxoS2tFczGkPLPgizskuemMghRniWaoLcyeh\nkd3qqGElvW/VDL5AaWTg0nLVkjRo9z+40RQzuVaE8AkAFmxZzow3x+VJYKdjykkJ\n0iT9wCS0DRTXu269V264Vf/3jvredZiKRkgwlL9xNAwxXFg0x/XFw005UWVRIkdg\ncKWTjpBP2dPwVZ4WWC+9aGVd+Gyn1o0CLelf4rEjGoXbAAEgAqeGUxrcIlbjXfbc\nmwIDAQAB\n-----END PUBLIC KEY-----","output":"str","x":370,"y":440,"wires":[["e5e50d62832729a3"]]},{"id":"f010d33f62711025","type":"debug","z":"d9e2b117923ec466","g":"b3ceb6dba19a60cd","name":"debug 4","active":true,"tosidebar":true,"console":false,"tostatus":false,"complete":"true","targetType":"full","statusVal":"","statusType":"auto","x":635,"y":440,"wires":[],"l":false}]
```

Цей потік підготовлено для декодування JWT токену, він складається з наступних вузлів:

- `Inject` - для запуску декодування
- `jwt` (тип `Template`) - для вставлення JWT маркера, який потрібно декодувати
- `public pem` (тип `Template`) - для вставлення публічного ключа, що використовується для перевірки підпису
- `from jwt` (тип `function`) - функція в якій відбувається декодування 
- `debug` - для відображення результату кодування

![image-20251210235948593](media/image-20251210235948593.png)

рис. 2. Фрагмент програми для декодування JWT

Функція імпортує пакунок `jsonwebtoken`, який описано в  [JSON Web Tokens в JS : теоретична частина](jwtjs.md). 

![image-20251211000707682](media/image-20251211000707682.png)

рис.3. Вкладка `Setup` вузла функції `from jwt`.

В самій функції виклик методу `verify` через обробник `try/catch`. Якщо є будь яка помилка обробки буде викликаний обробник `catch` який відправить на вивід об'єкт `err`.  

```js
try {
  //якщо немає помилки то вивести результа
  msg.payload = jsonwebtoken.verify(
    msg.jwt, msg.public_key, { algorithms: ['RS256'] });
} catch(err) {
  //якщо є помилка то вивести причиниу
  msg.err = err; 
}
return msg;
```

#### 4.2. Перша спроба

- [ ] Скопіюйте в вузол `jwt` токен, який Ви раніше згенерували.
- [ ] Скопіюйте в вузол `public pem` публічний сертифікат, який Ви зберегли. 
- [ ] Зробіть розгортання
- [ ] Ініціюйте обробку потоку (Inject).
- [ ] Проаналізуйте результат. Чи бачите Ви помилку? Якщо так, то чим вона зумовлена?

#### 4.3. Модифікація токена

- [ ] Використовуючи  encoder в jwt.io змініть дату публікації на теперішню а термін дії на 1000 секунд більше. Можете скористатися наступним потоком, імпортувавши його в Node-RED, який виводить плинну дату та час у потрібному форматі. 

```json
[{"id":"1078d7134b69fbb0","type":"group","z":"d9e2b117923ec466","name":"теперішня дата час в сек UTC","style":{"label":true},"nodes":["07888fae03f73241","13cf14361875a487","89dcce22f4e6dd61"],"x":64,"y":499,"w":282,"h":82},{"id":"07888fae03f73241","type":"inject","z":"d9e2b117923ec466","g":"1078d7134b69fbb0","name":"","props":[{"p":"payload"},{"p":"topic","vt":"str"}],"repeat":"","crontab":"","once":false,"onceDelay":0.1,"topic":"","payload":"","payloadType":"date","x":125,"y":540,"wires":[["89dcce22f4e6dd61"]],"l":false},{"id":"13cf14361875a487","type":"debug","z":"d9e2b117923ec466","g":"1078d7134b69fbb0","name":"debug 5","active":true,"tosidebar":true,"console":false,"tostatus":false,"complete":"false","statusVal":"","statusType":"auto","x":285,"y":540,"wires":[],"l":false},{"id":"89dcce22f4e6dd61","type":"change","z":"d9e2b117923ec466","g":"1078d7134b69fbb0","name":"","rules":[{"t":"set","p":"payload","pt":"msg","to":"payload / 1000","tot":"jsonata"}],"action":"","property":"","from":"","to":"","reg":false,"x":195,"y":540,"wires":[["13cf14361875a487"]],"l":false}]
```

- [ ] Перевірте токен jwt.io в режимі JWT Decoder. Зверніть увагу на дату та час, які підсвічуються.
- [ ] Скопіюйте токен в вузол `jwt` , зробіть розгортання і запустіть потік.
- [ ] Проаналізуйте результат. Декодовані значення мають бути в `msg.payload`
- [ ] Змініть у вузлі `jwt` останню літеру токена на якусь іншу. Зробіть розгортання і запустіть потік.
- [ ] Проаналізуйте результат. Чи бачите Ви помилку? Якщо так, то чим вона зумовлена?

### 5. Створення JWT-токену в Node-RED

#### 5.1. Імпорт потоку

- [ ] Імпортуйте потік, скопіювавши його в буфер з наведеного нижче коду

```json
[{"id":"dfd392d052aa00bd","type":"group","z":"d9e2b117923ec466","name":"створення JWT","style":{"label":true},"nodes":["08251aa3bf4a5508","004c9a87d9f9481b","b655eb01f6476a6a","38868cdad94f4d7b","e9451ea032dba75f","9052156bedeb44a1","690485551a294cc5"],"x":34,"y":599,"w":972,"h":82},{"id":"08251aa3bf4a5508","type":"inject","z":"d9e2b117923ec466","g":"dfd392d052aa00bd","name":"","props":[{"p":"now","v":"","vt":"date"},{"p":"topic","vt":"str"}],"repeat":"","crontab":"","once":false,"onceDelay":0.1,"topic":"","x":95,"y":640,"wires":[["004c9a87d9f9481b"]],"l":false},{"id":"004c9a87d9f9481b","type":"template","z":"d9e2b117923ec466","g":"dfd392d052aa00bd","name":"header","field":"inp.header","fieldType":"msg","format":"json","syntax":"plain","template":"{\n    \"alg\": \"RS256\",\n    \"typ\": \"JWT\"\n}","output":"json","x":210,"y":640,"wires":[["b655eb01f6476a6a"]]},{"id":"b655eb01f6476a6a","type":"template","z":"d9e2b117923ec466","g":"dfd392d052aa00bd","name":"payload","field":"inp.payload","fieldType":"msg","format":"json","syntax":"plain","template":"{\n    \"sub\": \"1234567890\",\n    \"iss\": \"self\",\n    \"name\": \"Oleksandr Pupena\",\n    \"admin\": true\n}","output":"json","x":360,"y":640,"wires":[["38868cdad94f4d7b"]]},{"id":"38868cdad94f4d7b","type":"template","z":"d9e2b117923ec466","g":"dfd392d052aa00bd","name":"public pem","field":"inp.public_key","fieldType":"msg","format":"text","syntax":"plain","template":"-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu1SU1LfVLPHCozMxH2Mo\n4lgOEePzNm0tRgeLezV6ffAt0gunVTLw7onLRnrq0/IzW7yWR7QkrmBL7jTKEn5u\n+qKhbwKfBstIs+bMY2Zkp18gnTxKLxoS2tFczGkPLPgizskuemMghRniWaoLcyeh\nkd3qqGElvW/VDL5AaWTg0nLVkjRo9z+40RQzuVaE8AkAFmxZzow3x+VJYKdjykkJ\n0iT9wCS0DRTXu269V264Vf/3jvredZiKRkgwlL9xNAwxXFg0x/XFw005UWVRIkdg\ncKWTjpBP2dPwVZ4WWC+9aGVd+Gyn1o0CLelf4rEjGoXbAAEgAqeGUxrcIlbjXfbc\nmwIDAQAB\n-----END PUBLIC KEY-----","output":"str","x":530,"y":640,"wires":[["690485551a294cc5"]]},{"id":"e9451ea032dba75f","type":"debug","z":"d9e2b117923ec466","g":"dfd392d052aa00bd","name":"debug 3","active":true,"tosidebar":true,"console":false,"tostatus":false,"complete":"true","targetType":"full","statusVal":"","statusType":"auto","x":945,"y":640,"wires":[],"l":false},{"id":"9052156bedeb44a1","type":"function","z":"d9e2b117923ec466","g":"dfd392d052aa00bd","name":"to jwt","func":"//дата та час в сек UTC\nconst now =  Math.floor(Date.now() / 1000);\nmsg.inp.payload.iat = now; \nmsg.inp.payload.exp = now + 3600;\n\nmsg.options = {\n  algorithm : msg.inp.header.alg,\n  header: {alg:msg.inp.header.alg,\n    typ:\"JWT\"} \n}\nmsg.payload = jsonwebtoken.sign (\n  msg.inp.payload, msg.inp.private_key, msg.options\n); \n\nreturn msg;","outputs":1,"timeout":0,"noerr":0,"initialize":"","finalize":"","libs":[{"var":"jsonwebtoken","module":"jsonwebtoken"}],"x":850,"y":640,"wires":[["e9451ea032dba75f"]]},{"id":"690485551a294cc5","type":"template","z":"d9e2b117923ec466","g":"dfd392d052aa00bd","name":"private pem","field":"inp.private_key","fieldType":"msg","format":"text","syntax":"plain","template":"-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC7VJTUt9Us8cKj\nMzEfYyjiWA4R4/M2bS1GB4t7NXp98C3SC6dVMvDuictGeurT8jNbvJZHtCSuYEvu\nNMoSfm76oqFvAp8Gy0iz5sxjZmSnXyCdPEovGhLa0VzMaQ8s+CLOyS56YyCFGeJZ\nqgtzJ6GR3eqoYSW9b9UMvkBpZODSctWSNGj3P7jRFDO5VoTwCQAWbFnOjDfH5Ulg\np2PKSQnSJP3AJLQNFNe7br1XbrhV//eO+t51mIpGSDCUv3E0DDFcWDTH9cXDTTlR\nZVEiR2BwpZOOkE/Z0/BVnhZYL71oZV34bKfWjQIt6V/isSMahdsAASACp4ZTGtwi\nVuNd9tybAgMBAAECggEBAKTmjaS6tkK8BlPXClTQ2vpz/N6uxDeS35mXpqasqskV\nlaAidgg/sWqpjXDbXr93otIMLlWsM+X0CqMDgSXKejLS2jx4GDjI1ZTXg++0AMJ8\nsJ74pWzVDOfmCEQ/7wXs3+cbnXhKriO8Z036q92Qc1+N87SI38nkGa0ABH9CN83H\nmQqt4fB7UdHzuIRe/me2PGhIq5ZBzj6h3BpoPGzEP+x3l9YmK8t/1cN0pqI+dQwY\ndgfGjackLu/2qH80MCF7IyQaseZUOJyKrCLtSD/Iixv/hzDEUPfOCjFDgTpzf3cw\nta8+oE4wHCo1iI1/4TlPkwmXx4qSXtmw4aQPz7IDQvECgYEA8KNThCO2gsC2I9PQ\nDM/8Cw0O983WCDY+oi+7JPiNAJwv5DYBqEZB1QYdj06YD16XlC/HAZMsMku1na2T\nN0driwenQQWzoev3g2S7gRDoS/FCJSI3jJ+kjgtaA7Qmzlgk1TxODN+G1H91HW7t\n0l7VnL27IWyYo2qRRK3jzxqUiPUCgYEAx0oQs2reBQGMVZnApD1jeq7n4MvNLcPv\nt8b/eU9iUv6Y4Mj0Suo/AU8lYZXm8ubbqAlwz2VSVunD2tOplHyMUrtCtObAfVDU\nAhCndKaA9gApgfb3xw1IKbuQ1u4IF1FJl3VtumfQn//LiH1B3rXhcdyo3/vIttEk\n48RakUKClU8CgYEAzV7W3COOlDDcQd935DdtKBFRAPRPAlspQUnzMi5eSHMD/ISL\nDY5IiQHbIH83D4bvXq0X7qQoSBSNP7Dvv3HYuqMhf0DaegrlBuJllFVVq9qPVRnK\nxt1Il2HgxOBvbhOT+9in1BzA+YJ99UzC85O0Qz06A+CmtHEy4aZ2kj5hHjECgYEA\nmNS4+A8Fkss8Js1RieK2LniBxMgmYml3pfVLKGnzmng7H2+cwPLhPIzIuwytXywh\n2bzbsYEfYx3EoEVgMEpPhoarQnYPukrJO4gwE2o5Te6T5mJSZGlQJQj9q4ZB2Dfz\net6INsK0oG8XVGXSpQvQh3RUYekCZQkBBFcpqWpbIEsCgYAnM3DQf3FJoSnXaMhr\nVBIovic5l0xFkEHskAjFTevO86Fsz1C2aSeRKSqGFoOQ0tmJzBEs1R6KqnHInicD\nTQrKhArgLXX4v3CddjfTRJkFWDbE/CkvKZNOrcf1nhaGCPspRJj2KUkj1Fhl9Cnc\ndn/RsYEONbwQSjIfMPkvxF+8HQ==\n-----END PRIVATE KEY-----","output":"str","x":710,"y":640,"wires":[["9052156bedeb44a1"]]}]
```

На рис.4 показаний зовнішній вигляд потоку, він включає наступні вузли:

- `header` (`template`) - для заповнення заголовку
- `payload`(`template`) - для заповнення корисного навантаження 
- `public pem` (`template`) - для збереження публічного ключа
- `private pem` (`template`) - для збереження приватного ключа
- `to jwt` (`function`) - функція генерування jwt

![image-20251211005601376](media/image-20251211005601376.png)

рис.4. Фрагмент програми для створення токена JWT

В самій функції виклик методу `sign` імпортованого об'єкту `jsonwebtoken`, результат передається в  `payload`.

```js
//дата та час в сек UTC
const now =  Math.floor(Date.now() / 1000);
msg.inp.payload.iat = now; 
msg.inp.payload.exp = now + 3600;

msg.options = {
  algorithm : msg.inp.header.alg,
  header: {alg:msg.inp.header.alg,
    typ:"JWT"} 
}
msg.payload = jsonwebtoken.sign (
  msg.inp.payload, msg.inp.private_key, msg.options
); 

return msg;
```

#### 5.2.Генерування токену

- [ ] Змініть у вузлі `payload` значення поля `name` та добавте поле `iss` зі значенням `"self"`.  
- [ ] Зробіть розгортання потоку. Запустіть генерування токену. 
- [ ] Скопіюйте токен (з вікна Debug) і перевірте його за допомогою JWT Decoder в сервісі jwt.io 

## Додаток 1

Нижче наводяться приклади ключів та JWT токену.

Приклад публічного ключа для jwt.io

```
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAu1SU1LfVLPHCozMxH2Mo
4lgOEePzNm0tRgeLezV6ffAt0gunVTLw7onLRnrq0/IzW7yWR7QkrmBL7jTKEn5u
+qKhbwKfBstIs+bMY2Zkp18gnTxKLxoS2tFczGkPLPgizskuemMghRniWaoLcyeh
kd3qqGElvW/VDL5AaWTg0nLVkjRo9z+40RQzuVaE8AkAFmxZzow3x+VJYKdjykkJ
0iT9wCS0DRTXu269V264Vf/3jvredZiKRkgwlL9xNAwxXFg0x/XFw005UWVRIkdg
cKWTjpBP2dPwVZ4WWC+9aGVd+Gyn1o0CLelf4rEjGoXbAAEgAqeGUxrcIlbjXfbc
mwIDAQAB
-----END PUBLIC KEY-----
```

Приклад приватного ключа для jwt.io

```
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC7VJTUt9Us8cKj
MzEfYyjiWA4R4/M2bS1GB4t7NXp98C3SC6dVMvDuictGeurT8jNbvJZHtCSuYEvu
NMoSfm76oqFvAp8Gy0iz5sxjZmSnXyCdPEovGhLa0VzMaQ8s+CLOyS56YyCFGeJZ
qgtzJ6GR3eqoYSW9b9UMvkBpZODSctWSNGj3P7jRFDO5VoTwCQAWbFnOjDfH5Ulg
p2PKSQnSJP3AJLQNFNe7br1XbrhV//eO+t51mIpGSDCUv3E0DDFcWDTH9cXDTTlR
ZVEiR2BwpZOOkE/Z0/BVnhZYL71oZV34bKfWjQIt6V/isSMahdsAASACp4ZTGtwi
VuNd9tybAgMBAAECggEBAKTmjaS6tkK8BlPXClTQ2vpz/N6uxDeS35mXpqasqskV
laAidgg/sWqpjXDbXr93otIMLlWsM+X0CqMDgSXKejLS2jx4GDjI1ZTXg++0AMJ8
sJ74pWzVDOfmCEQ/7wXs3+cbnXhKriO8Z036q92Qc1+N87SI38nkGa0ABH9CN83H
mQqt4fB7UdHzuIRe/me2PGhIq5ZBzj6h3BpoPGzEP+x3l9YmK8t/1cN0pqI+dQwY
dgfGjackLu/2qH80MCF7IyQaseZUOJyKrCLtSD/Iixv/hzDEUPfOCjFDgTpzf3cw
ta8+oE4wHCo1iI1/4TlPkwmXx4qSXtmw4aQPz7IDQvECgYEA8KNThCO2gsC2I9PQ
DM/8Cw0O983WCDY+oi+7JPiNAJwv5DYBqEZB1QYdj06YD16XlC/HAZMsMku1na2T
N0driwenQQWzoev3g2S7gRDoS/FCJSI3jJ+kjgtaA7Qmzlgk1TxODN+G1H91HW7t
0l7VnL27IWyYo2qRRK3jzxqUiPUCgYEAx0oQs2reBQGMVZnApD1jeq7n4MvNLcPv
t8b/eU9iUv6Y4Mj0Suo/AU8lYZXm8ubbqAlwz2VSVunD2tOplHyMUrtCtObAfVDU
AhCndKaA9gApgfb3xw1IKbuQ1u4IF1FJl3VtumfQn//LiH1B3rXhcdyo3/vIttEk
48RakUKClU8CgYEAzV7W3COOlDDcQd935DdtKBFRAPRPAlspQUnzMi5eSHMD/ISL
DY5IiQHbIH83D4bvXq0X7qQoSBSNP7Dvv3HYuqMhf0DaegrlBuJllFVVq9qPVRnK
xt1Il2HgxOBvbhOT+9in1BzA+YJ99UzC85O0Qz06A+CmtHEy4aZ2kj5hHjECgYEA
mNS4+A8Fkss8Js1RieK2LniBxMgmYml3pfVLKGnzmng7H2+cwPLhPIzIuwytXywh
2bzbsYEfYx3EoEVgMEpPhoarQnYPukrJO4gwE2o5Te6T5mJSZGlQJQj9q4ZB2Dfz
et6INsK0oG8XVGXSpQvQh3RUYekCZQkBBFcpqWpbIEsCgYAnM3DQf3FJoSnXaMhr
VBIovic5l0xFkEHskAjFTevO86Fsz1C2aSeRKSqGFoOQ0tmJzBEs1R6KqnHInicD
TQrKhArgLXX4v3CddjfTRJkFWDbE/CkvKZNOrcf1nhaGCPspRJj2KUkj1Fhl9Cnc
dn/RsYEONbwQSjIfMPkvxF+8HQ==
-----END PRIVATE KEY-----
```

Приклад JWT маркера

```
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6Ik9sZWtzYW5kciBQdXBlbmEiLCJhZG1pbiI6dHJ1ZSwiaWF0IjoxNTE2MjM5MDIyLCJleHAiOjE1MTYyMzkwMjJ9.SIzI8ai6WR-KsNTYUDyNgkMvO5xCS9giEHXwVX4ifU-2GrFuinZKPL1FMZCE8v1FXiB87RbZ3Az7spGRYt1rt8SQFXuKtmY6dAeNo5j7VfnCkhXzXHRfAJJZ6EbAOMTRSL4s7F7bJLdkYt6i5fVADUK6Deo_r-0X8Yt-slEtPCBGwyg4bpauxN1-mAnlfS-axKkxRoaCZ-2Uhhhqoc3DsShaEC3PjV3tyLjiPTCNWy8gxi7xxynU17Le5dCVxcIUoS8eirYQZJQq3p9ELMZXXBhmV3IBhxfrJGWJqRP-x9mt6ufHfL0N64gyfIUGOMRuvmCDbUxC3ijU822fRquZFg
```

## Питання до захисту

1. Розкажіть про призначення JWT токенів.
2. Розкажіть про можливості сервісу jwt.io, які використовувалися на практичній роботі. 
3. Назвіть з яких частин складається JWT токен. 
4. Яка частина токена JWT шифрується? Для чого це потрібно?
5. Які твердження (claims) з корисного навантаження використовувалися в практичній роботі? Яке їх призначення?
6. Які помилки було визначено при верифікації JWT в практичній роботі?
7. Який пакунок JS використовувався в практичній роботі? Як він інтегрувався в Node-RED?
8. Які методи були використані для створення JWT токену та його перевірки?
9. Чому було використано пару ключів (приватний і публічний) замість одного? Чим це визначається?
10. Який алгоритм шифрування використовувався в практичній роботі? Де це вказувалося?
11. Які поля опцій були використані для створення JWT та його верифікації?   



## Автор

Практичне заняття розробив [Олександр Пупена](https://github.com/pupenasan). 



## Feedback

Якщо Ви хочете залишити коментар у Вас є наступні варіанти:

- [Обговорення у WhatsApp](https://chat.whatsapp.com/BRbPAQrE1s7BwCLtNtMoqN)
- [Обговорення в Телеграм](https://t.me/+GA2smCKs5QU1MWMy)
- [Група у Фейсбуці](https://www.facebook.com/groups/asu.in.ua)

Про проект і можливість допомогти проекту написано [тут](https://asu-in-ua.github.io/atpv/)

