[<- До підрозділу](README.md) 			[Коментувати](#feedback)

# JSON Web Tokens в JS : теоретична частина

## 1. Бібліотека JS - jsonwebtoken

У даному пункті використані матеріали [з репозиторію jsonwebtoken](https://github.com/auth0/node-jsonwebtoken#readme)

### Про бібліотеку

Бібліотека `jsonwebtoken` використовується для роботи з веб-токенами в JS в тому числі Node.js. Встановлення:

```bash
$ npm install jsonwebtoken
```

Має три методи:

- `sign` - Формує  JsonWebToken як рядок за вказаним корисним навантаженням, секретним приватним ключем та опціями 
- `verify` - повертає розшифроване корисне навантаження за вказаним JsonWebToken, якщо підпис дійсний і необов’язковий термін дії, аудиторія чи емітент дійсні, якщо ні - видасть помилку.
- `decode` - повертає розшифроване корисне навантаження без перевірки дійсності підпису.

### Метод `sign`

Формує  JsonWebToken як рядок  за вказаним корисним навантаженням, секретним приватним ключем та опціями. 

Може працювати в асинхронному або синхронному режимі:

- (Асинхронний) Якщо надається зворотний виклик, зворотний виклик викликається з `err` або JWT.
- (Синхронно) Повертає JsonWebToken як рядок

```js
jwt.sign(payload, secretOrPrivateKey, [options, callback])
```

- `payload` може бути літералом об’єкта, буфером або рядком, що представляє дійсний JSON.  **Зауважте, що** `exp` або будь-який інший payload встановлюється тільки у тому випадку, якщо корисне навантаження є літералом об’єкта. Корисне навантаження типу `bufe`r або `string` не перевіряється на дійсність JSON. Якщо `payload` не є буфером або рядком, його буде переведено в рядок за допомогою `JSON.stringify`.

- `secretOrPrivateKey` - це рядок (закодований utf-8), буфер, об’єкт або `KeyObject`, що містить або секрет для алгоритмів HMAC, або закритий ключ у кодуванні PEM для RSA та ECDSA. У випадку закритого ключа з парольною фразою можна використовувати об’єкт `{ key, passphrase }` (на основі [криптодокументації](https://nodejs.org/api/crypto.html#crypto_sign_sign_private_key_output_format)), у цьому випадку переконайтеся, що ви передали параметр `algorithm`. Під час підписання за допомогою алгоритмів RSA мінімальна довжина модуля становить 2048, за винятком випадків, коли для параметра `allowInsecureKeySizes` встановлено значення `true`. Приватні ключі менше цього розміру будуть відхилені з помилкою.

- `options`:
- `algorithm` (default: `HS256`)
  
- `expiresIn`: виражений у секундах або рядок, що описує проміжок часу  [vercel/ms](https://github.com/vercel/ms). Наприклад: `60`, `"2 days"`, `"10h"`, `"7d"`. Числове значення інтерпретується як кількість секунд. Якщо ви використовуєте рядок, переконайтеся, що ви вказали одиниці часу (days, hours, тощо), інакше за замовчуванням використовуються одиниці вимірювання мілісекунди (`120` дорівнює 120 мс).
  
- `notBefore`: виражений у секундах або рядок, що описує проміжок часу  [vercel/ms](https://github.com/vercel/ms). 
  
- `audience`
  
- `issuer`
  
- `jwtid`
  
- `subject`
  
- `noTimestamp`
  
- `header` - заголовок
  
- `keyid`
  
- `mutatePayload`: якщо істина, функція `sign` безпосередньо змінюватиме об’єкт корисного навантаження. Це корисно, якщо вам потрібно необроблене посилання на корисне навантаження після того, як до нього було застосовано твердження, але до того, як його було закодовано в маркер.
  
- `allowInsecureKeySizes`: якщо true, дозволяє використовувати приватні ключі з модулем нижче 2048 для RSA
  
- `allowInvalidAsymmetricKeyTypes`: якщо істина, дозволяє асиметричні ключі, які не відповідають указаному алгоритму. Цей параметр призначений лише для зворотної сумісності, і його слід уникати.

Немає значень за умовчанням для `expiresIn`, `notBefore`, `audience`, `subject`, `issuer`. Ці твердження також можна надати в корисному навантаженні безпосередньо за допомогою `exp`, `nbf`, `aud`, `sub` і `iss` відповідно, але ви ***не можете*** включити в обидва місця і в опції і в корисне навантаження.

Пам’ятайте, що `exp`, `nbf` і `iat` є **NumericDate**, див. пов’язану [Token Expiration (exp claim)](https://github.com/auth0/node-jsonwebtoken#token-expiration-exp-claim)

Заголовок можна налаштувати за допомогою об’єкта `options.header`.

Згенеровані jwts за замовчуванням включатимуть твердження `iat` (випущено о), якщо не вказано `noTimestamp`. Якщо `iat` вставлено в корисне навантаження, воно використовуватиметься замість реальної мітки часу для обчислення інших речей, таких як `exp`, враховуючи проміжок часу в `options.expiresIn`.

Синхронний знак за умовчанням (HMAC SHA256)

```js
var jwt = require('jsonwebtoken');
var token = jwt.sign({ foo: 'bar' }, 'shhhhh');
```

Синхронне підписування із RSA SHA256

```js
// sign with RSA SHA256
var privateKey = fs.readFileSync('private.key');
var token = jwt.sign({ foo: 'bar' }, privateKey, { algorithm: 'RS256' });
```

Асинхронне підписування

```js
jwt.sign({ foo: 'bar' }, privateKey, { algorithm: 'RS256' }, function(err, token) {
  console.log(token);
});
```

Зворотня дата (Backdate ) на 30 секунд назад

```js
var older_token = jwt.sign({ foo: 'bar', iat: Math.floor(Date.now() / 1000) - 30 }, 'shhhhh');
```

#### Token Expiration (exp claim)

Стандарт для JWT означує вимогу `exp` для закінчення терміну дії. Термін дії представлено як **NumericDate** - це числове значення JSON, що представляє кількість секунд від 1970-01-01T00:00:00Z UTC до вказаної дати/часу UTC, ігноруючи високосні секунди. Це еквівалентно визначенню IEEE Std 1003.1, 2013 Edition [POSIX.1] «Секунди з епохи», у якому кожен день враховується рівно 86400 секундами, крім цього можуть бути представлені нецілі значення. Перегляньте RFC 3339 [RFC3339], щоб дізнатися більше про дату/час загалом і UTC зокрема.

Це означає, що поле `exp` має містити кількість секунд після епохи.

Підписання токена з терміном дії 1 година матиме наступний вигляд:

```javascript
jwt.sign({
  exp: Math.floor(Date.now() / 1000) + (60 * 60),
  data: 'foobar'
}, 'secret');
```

Ще один спосіб створити подібний маркер за допомогою цієї бібліотеки:

```javascript
jwt.sign({
  data: 'foobar'
}, 'secret', { expiresIn: 60 * 60 });

//or even better:

jwt.sign({
  data: 'foobar'
}, 'secret', { expiresIn: '1h' });
```

#### Підтримувані алгоритми

Масив підтримуваних алгоритмів. Наразі підтримуються такі алгоритми.

| alg Parameter Value | Digital Signature or MAC Algorithm                           |
| ------------------- | ------------------------------------------------------------ |
| HS256               | HMAC using SHA-256 hash algorithm                            |
| HS384               | HMAC using SHA-384 hash algorithm                            |
| HS512               | HMAC using SHA-512 hash algorithm                            |
| RS256               | RSASSA-PKCS1-v1_5 using SHA-256 hash algorithm               |
| RS384               | RSASSA-PKCS1-v1_5 using SHA-384 hash algorithm               |
| RS512               | RSASSA-PKCS1-v1_5 using SHA-512 hash algorithm               |
| PS256               | RSASSA-PSS using SHA-256 hash algorithm (only node ^6.12.0 OR >=8.0.0) |
| PS384               | RSASSA-PSS using SHA-384 hash algorithm (only node ^6.12.0 OR >=8.0.0) |
| PS512               | RSASSA-PSS using SHA-512 hash algorithm (only node ^6.12.0 OR >=8.0.0) |
| ES256               | ECDSA using P-256 curve and SHA-256 hash algorithm           |
| ES384               | ECDSA using P-384 curve and SHA-384 hash algorithm           |
| ES512               | ECDSA using P-521 curve and SHA-512 hash algorithm           |
| none                | No digital signature or MAC value included                   |

### Метод verify

Повертає розшифроване корисне навантаження за вказаним JsonWebToken, якщо підпис дійсний і необов’язковий термін дії, аудиторія чи емітент дійсні, якщо ні - видасть помилку. Має синхронний і асинхронний спосіб застосування

```js
jwt.verify(token, secretOrPublicKey, [options, callback])
```

(Асинхронний) Якщо надається зворотний виклик, функція діє асинхронно. Зворотний виклик викликається з розшифрованим корисним навантаженням, якщо підпис дійсний і необов’язковий термін дії, аудиторія або емітент дійсні. Якщо ні, буде викликано з помилкою.

(Синхронно) Якщо зворотний виклик не надається, функція діє синхронно. Повертає розшифроване корисне навантаження, якщо підпис дійсний і необов’язковий термін дії, аудиторія чи емітент дійсні. Якщо ні, це видасть помилку. **Попередження.** Якщо токен надходить із ненадійного джерела (наприклад, введені користувачем або зовнішні запити), повернуте декодоване корисне навантаження слід розглядати як будь-які інші введені користувачем дані; обов’язково продезінфікуйте та працюйте лише з очікуваними властивостями

- `token` is the JsonWebToken string

- `secretOrPublicKey` це рядок (закодований utf-8), буфер або KeyObject, що містить або секрет для алгоритмів HMAC, або відкритий ключ у кодуванні PEM для RSA та ECDSA. Якщо `jwt.verify` називається асинхронним, `secretOrPublicKey` може бути функцією, яка має отримати секретний або відкритий ключ. Детальний приклад див. нижче. Як зазначено в [цьому коментарі](https://github.com/auth0/node-jsonwebtoken/issues/208#issuecomment-231861138), існують інші бібліотеки, які очікують секретів, закодованих base64 (випадкові байти, закодовані за допомогою base64), якщо це у вашому випадку ви можете передати `Buffer.from(secret, 'base64')`, таким чином секрет буде розшифровано за допомогою base64, а перевірка маркера використовуватиме вихідні випадкові байти.

- `options`

  - `algorithms` : Список рядків з назвами дозволених алгоритмів. Наприклад, (`["HS256", "HS384"]`) Якщо не вказано, буде використано значення за замовчуванням на основі типу наданого ключа
- `secret` - `['HS256', 'HS384', 'HS512']`
    
- `rsa` - `['RS256', 'RS384', 'RS512']`
    
- `ec` - `['ES256', 'ES384', 'ES512']`
    
- `default` - `['RS256', 'RS384', 'RS512']`


  - `audience` : якщо ви хочете перевірити аудиторію (`aud`), введіть тут значення. Аудиторію можна перевірити за рядком, регулярним виразом або списком рядків і/або регулярних виразів. наприклад:`"urn:foo"`, `/urn:f[o]{2}/`, `[/urn:f[o]{2}/, "urn:bar"]` 

- `complete`: return an object with the decoded `{ payload, header, signature }` instead of only the usual content of the payload.


  - `issuer` (optional): string or array of strings of valid values for the `iss` field.

- `jwtid` (optional): if you want to check JWT ID (`jti`), provide a string value here.


  - `ignoreExpiration`: if `true` do not validate the expiration of the token.

- `ignoreNotBefore`...


  - `subject`: if you want to check subject (`sub`), provide a value here

- `clockTolerance`: number of seconds to tolerate when checking the `nbf` and `exp` claims, to deal with small clock differences among different servers


  - `maxAge`: the maximum allowed age for tokens to still be valid. It is expressed in seconds or a string describing a time span vercel/ms

- `clockTimestamp`: the time in seconds that should be used as the current time for all necessary comparisons.


  - `nonce`: if you want to check `nonce` claim, provide a string value here. It is used on Open ID for the ID Tokens. ([Open ID implementation notes](https://openid.net/specs/openid-connect-core-1_0.html#NonceNotes))

- `allowInvalidAsymmetricKeyTypes`: if true, allows  asymmetric keys which do not match the specified algorithm. This option  is intended only for backwards compatability and should be avoided.

```js
// verify a token symmetric - synchronous
var decoded = jwt.verify(token, 'shhhhh');
console.log(decoded.foo) // bar

// verify a token symmetric
jwt.verify(token, 'shhhhh', function(err, decoded) {
  console.log(decoded.foo) // bar
});

// invalid token - synchronous
try {
  var decoded = jwt.verify(token, 'wrong-secret');
} catch(err) {
  // err
}

// invalid token
jwt.verify(token, 'wrong-secret', function(err, decoded) {
  // err
  // decoded undefined
});

// verify a token asymmetric
var cert = fs.readFileSync('public.pem');  // get public key
jwt.verify(token, cert, function(err, decoded) {
  console.log(decoded.foo) // bar
});

// verify audience
var cert = fs.readFileSync('public.pem');  // get public key
jwt.verify(token, cert, { audience: 'urn:foo' }, function(err, decoded) {
  // if audience mismatch, err == invalid audience
});

// verify issuer
var cert = fs.readFileSync('public.pem');  // get public key
jwt.verify(token, cert, { audience: 'urn:foo', issuer: 'urn:issuer' }, function(err, decoded) {
  // if issuer mismatch, err == invalid issuer
});

// verify jwt id
var cert = fs.readFileSync('public.pem');  // get public key
jwt.verify(token, cert, { audience: 'urn:foo', issuer: 'urn:issuer', jwtid: 'jwtid' }, function(err, decoded) {
  // if jwt id mismatch, err == invalid jwt id
});

// verify subject
var cert = fs.readFileSync('public.pem');  // get public key
jwt.verify(token, cert, { audience: 'urn:foo', issuer: 'urn:issuer', jwtid: 'jwtid', subject: 'subject' }, function(err, decoded) {
  // if subject mismatch, err == invalid subject
});

// alg mismatch
var cert = fs.readFileSync('public.pem'); // get public key
jwt.verify(token, cert, { algorithms: ['RS256'] }, function (err, payload) {
  // if token alg != RS256,  err == invalid signature
});

// Verify using getKey callback
// Example uses https://github.com/auth0/node-jwks-rsa as a way to fetch the keys.
var jwksClient = require('jwks-rsa');
var client = jwksClient({
  jwksUri: 'https://sandrino.auth0.com/.well-known/jwks.json'
});
function getKey(header, callback){
  client.getSigningKey(header.kid, function(err, key) {
    var signingKey = key.publicKey || key.rsaPublicKey;
    callback(null, signingKey);
  });
}

jwt.verify(token, getKey, options, function(err, decoded) {
  console.log(decoded.foo) // bar
});
```

### Метод decode

Повертає розшифроване корисне навантаження без перевірки дійсності підпису. Є синхронним.

```
jwt.decode(token [, options])
```

Повертає розшифроване корисне навантаження без перевірки дійсності підпису.

**Попередження:** це **не** перевірить, чи дійсний підпис. Вам **не** слід використовувати це для ненадійних повідомлень. Швидше за все, ви захочете використовувати замість цього `jwt.verify`. **Попередження.** Якщо маркер надходить із ненадійного джерела (наприклад, введення користувача або зовнішній запит), повернуте декодоване корисне навантаження слід розглядати як будь-який інший ввід користувача; обов’язково продезінфікуйте та працюйте лише з очікуваними властивостями

- `token` is the JsonWebToken string

- `options`:

  - `json`: force JSON.parse on the payload even if the header doesn't contain `"typ":"JWT"`.

  - `complete`: return an object with the decoded payload and header.

приклад

```js
// get the decoded payload ignoring signature, no secretOrPrivateKey needed
var decoded = jwt.decode(token);

// get the decoded payload and header
var decoded = jwt.decode(token, {complete: true});
console.log(decoded.header);
console.log(decoded.payload)
```

### Помилки та коди 

Можливі помилки під час перевірки. Помилка є першим аргументом зворотного виклику перевірки.

#### TokenExpiredError

Виникла помилка, якщо термін дії маркера минув. Об'єкт помилки:

- name: 'TokenExpiredError'
- message: 'jwt expired'
- expiredAt: [ExpDate]

```js
jwt.verify(token, 'shhhhh', function(err, decoded) {
  if (err) {
    /*
      err = {
        name: 'TokenExpiredError',
        message: 'jwt expired',
        expiredAt: 1408621000
      }
    */
  }
});
```

#### JsonWebTokenError

Error object:

- `name`: 'JsonWebTokenError'
- `message`:
  - 'invalid token' - the header or payload could not be parsed
  - 'jwt malformed' - the token does not have three components (delimited by a `.`)
  - 'jwt signature is required'
  - 'invalid signature'
  - 'jwt audience invalid. expected: [OPTIONS AUDIENCE]'
  - 'jwt issuer invalid. expected: [OPTIONS ISSUER]'
  - 'jwt id invalid. expected: [OPTIONS JWT ID]'
  - 'jwt subject invalid. expected: [OPTIONS SUBJECT]'

```js
jwt.verify(token, 'shhhhh', function(err, decoded) {
  if (err) {
    /*
      err = {
        name: 'JsonWebTokenError',
        message: 'jwt malformed'
      }
    */
  }
});
```

#### NotBeforeError

Видається, якщо поточний час передує запиту nbf. Об'єкт помилки:

- name: 'NotBeforeError'
- message: 'jwt not active'
- date: 2018-10-04T16:10:44.000Z

```js
jwt.verify(token, 'shhhhh', function(err, decoded) {
  if (err) {
    /*
      err = {
        name: 'NotBeforeError',
        message: 'jwt not active',
        date: 2018-10-04T16:10:44.000Z
      }
    */
  }
});
```

### Оновлення JWT

Перш за все, ми рекомендуємо вам уважно подумати, чи не призведе автоматичне оновлення JWT до вразливості вашої системи.

Нам не зручно включати це як частину бібліотеки, однак ви можете поглянути на [цей приклад](https://gist.github.com/ziluvatar/a3feb505c4c0ec37059054537b38fc48), щоб показати, як це можна зробити. Окрім цього прикладу, є [проблема](https://github.com/auth0/node-jsonwebtoken/issues/122) і [запит на отримання](https://github.com/auth0/node-jsonwebtoken/ pull/172), щоб отримати більше знань про цю тему.



# Посилання

http://auth0.com/learn/json-web-tokens



## Автори


Це адаптація матеріалів http://auth0.com/learn/json-web-tokens. Адаптовано  [Олександром Пупеною](https://github.com/pupenasan). 

## Feedback

Якщо Ви хочете залишити коментар у Вас є наступні варіанти:

- [Обговорення у WhatsApp](https://chat.whatsapp.com/BRbPAQrE1s7BwCLtNtMoqN)
- [Обговорення в Телеграм](https://t.me/+GA2smCKs5QU1MWMy)
- [Група у Фейсбуці](https://www.facebook.com/groups/asu.in.ua)

Про проект і можливість допомогти проекту написано [тут](https://asu-in-ua.github.io/atpv/)