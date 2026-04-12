[<- До підрозділу](README.md)		[Коментувати](#feedback)

# External API: теоретична частина

це чернетка

https://www.odoo.com/documentation/17.0/developer/reference/external_api.html

## 1. Загальні поняття

Odoo зазвичай розширюється внутрішньо за допомогою модулів, однак багато його можливостей і всі дані також доступні ззовні для зовнішнього аналізу або інтеграції з різними інструментами. Частина API моделей (Models API) легко доступна через [XML-RPC](../../distribap/xmlrpc/teor.md) і може використовуватися з різних мов програмування.

- url (URL сервера) - це домен інстансу (наприклад https://mycompany.odoo.com), 
- db (ім’я бази даних) - це назва інстансу (наприклад `mycompany`), якщо локальне розгортання ім'я, то це назва бази данних. 
- username (Ім’я користувача) - це логін налаштованого користувача, як показано на екрані Change Password.

```python
url = <insert server URL>
db = <insert database name>
username = 'admin'
password = <insert password for your admin user (default: admin)>
```

## API Keys

Odoo підтримує API-ключі і (залежно від модулів або налаштувань) може вимагати їх для виконання операцій веб-сервісів. Спосіб використання API-ключів у ваших скриптах дуже простий: потрібно просто замінити пароль на ключ. Логін користувача при цьому залишається тим самим. API-ключ слід зберігати так само обережно, як і пароль, оскільки він фактично надає той самий рівень доступу до облікового запису користувача (хоча за допомогою нього не можна увійти через веб-інтерфейс).

Щоб додати ключ до свого облікового запису, перейдіть у Preferences (або My Profile). Далі відкрийте вкладку Account Security і натисніть New API Key.

Введіть опис ключа. Опис має бути максимально зрозумілим і повним, оскільки це єдиний спосіб надалі ідентифікувати ключ і зрозуміти, чи потрібно його видалити, чи залишити.

Натисніть Generate Key, після чого скопіюйте згенерований ключ. Збережіть його у безпечному місці. Цей ключ еквівалентний вашому паролю, і так само як пароль, система не зможе пізніше знову показати або відновити цей ключ. Якщо ви втратите ключ, доведеться створити новий (і, ймовірно, видалити втрачений).

Після того як ключі будуть створені для вашого облікового запису, вони відображатимуться над кнопкою New API Key. Там же їх можна видаляти.

Видалений API-ключ не можна відновити або повторно активувати. Потрібно згенерувати новий ключ і оновити його у всіх місцях, де використовувався старий.

## Вхід у систему

Odoo вимагає, щоб користувачі API були автентифіковані перед тим, як вони зможуть отримувати більшість даних.

Кінцева точка `xmlrpc/2/common` надає мета-виклики, які не потребують автентифікації, наприклад саму автентифікацію або отримання інформації про версію сервера. Щоб перевірити, чи правильно задані параметри підключення перед спробою автентифікації, найпростіше виконати запит на отримання версії сервера.

Сама автентифікація виконується через функцію `authenticate` і повертає ідентифікатор користувача (uid), який використовується в автентифікованих викликах замість логіна.

```python
common = xmlrpc.client.ServerProxy('{}/xmlrpc/2/common'.format(url))
common.version()
```

результат:

```json
{
    "server_version": "13.0",
    "server_version_info": [13, 0, 0, "final", 0],
    "server_serie": "13.0",
    "protocol_version": 1,
}
```

```python
uid = common.authenticate(db, username, password, {})
```

## Виклик методів

Друга кінцева точка - `xmlrpc/2/object`. Вона використовується для виклику методів моделей Odoo через RPC-функцію `execute_kw`.

Кожен виклик `execute_kw` приймає такі параметри:

- база даних, яку потрібно використовувати, рядок
- ідентифікатор користувача (отриманий через `authenticate`), ціле число
- пароль користувача, рядок
- назва моделі, рядок
- назва методу, рядок
- масив або список параметрів, які передаються позиційно
- словник параметрів, які передаються за ключами (необов’язково)

Наприклад, щоб перевірити, чи можемо ми читати модель `res.partner`, можна викликати метод `check_access_rights`, передавши параметр `operation` позиційно, а параметр `raise_exception` - як іменований параметр (щоб отримати результат `true/false`, а не `true/error`).

```python
models = xmlrpc.client.ServerProxy('{}/xmlrpc/2/object'.format(url))
models.execute_kw(db, uid, password, 'res.partner', 'check_access_rights', ['read'], {'raise_exception': False})
```

## Список записів `search`

Записи можна отримувати у вигляді списку та фільтрувати за допомогою методу `search()`. Метод `search()` приймає обов’язковий фільтр `domain` (який може бути порожнім) і повертає ідентифікатори в базі даних усіх записів, що відповідають цьому фільтру.

Наприклад, щоб отримати список компаній-клієнтів:

```python
models.execute_kw(db, uid, password, 'res.partner', 'search', [[['is_company', '=', True]]])
```

результат:

```
[7, 18, 12, 14, 17, 19, 8, 31, 26, 16, 13, 20, 30, 22, 29, 15, 23, 28, 74]
```

Параметр виглядає як

```
[[['is_company', '=', True]]]
```

тому що структура аргументів у `execute_kw` має кілька рівнів вкладеності.

Розберемо виклик:

Тут є три рівні:

- рівень виклику методу Odoo

```
execute_kw(db, uid, password, model, method, args)
```

де `args = [...]` завжди є масивом аргументів методу

- аргументи методу `search`, який має сигнатуру

```
search(domain, offset=0, limit=None, order=None)
```

- перший параметр - `domain`, тому у `args` передається: `args = [domain]`
- сам `domain` , який в Odoo завжди є списком умов: `domain = [['is_company', '=', True]]`

- Кожна умова - це `[field, operator, value]`

Структура виглядає так:

```
args
 └─ domain
     └─ condition
         ├─ field
         ├─ operator
         └─ value
```

## Пагінація

За замовчуванням метод `search` повертає ідентифікатори всіх записів, що відповідають умові. Таких записів може бути дуже багато. Параметри `offset` та `limit` дозволяють отримати лише частину знайдених записів.

```python
models.execute_kw(db, uid, password, 'res.partner', 'search', [[['is_company', '=', True]]], {'offset': 10, 'limit': 5})
```

результат:

```
[13, 20, 30, 22, 29]
```

## Підрахунок записів

Замість отримання потенційно дуже великого списку записів і подальшого їх підрахунку, можна використати метод `search_count()`, який повертає лише кількість записів, що відповідають запиту. Він приймає той самий фільтр `domain`, що і `search()`, і не має інших параметрів.

```python
models.execute_kw(db, uid, password, 'res.partner', 'search_count', [[['is_company', '=', True]]])
```

результат:

```
19
```

Виклик `search`, а потім `search_count` (або у зворотному порядку) може не дати узгоджених результатів, якщо сервером одночасно користуються інші користувачі: дані у сховищі могли змінитися між цими викликами.

## Читання записів

Дані записів доступні через метод `read()`, який приймає список ідентифікаторів (як ті, що повертає `search()`), а також, за потреби, список полів, які потрібно отримати. За замовчуванням метод повертає всі поля, які поточний користувач має право читати. Зазвичай це досить велика кількість полів.

```python
ids = models.execute_kw(db, uid, password, 'res.partner', 'search', [[['is_company', '=', True]]], {'limit': 1})
[record] = models.execute_kw(db, uid, password, 'res.partner', 'read', [ids])
# count the number of fields fetched by default
len(record)
```

результат:

```
121
```

Натомість можна вибрати лише три поля, які вважаються цікавими.

```python
models.execute_kw(db, uid, password, 'res.partner', 'read', [ids], {'fields': ['name', 'country_id', 'comment']})
```

результат:

```
[{"comment": false, "country_id": [21, "Belgium"], "id": 7, "name": "Agrolait"}]
```

Навіть якщо поле `id` не запитувалося, воно завжди повертається.

## Список полів запису

Метод `fields_get()` можна використовувати для перегляду полів моделі та перевірки, які з них можуть бути цікавими.

Оскільки цей метод повертає велику кількість метаінформації (він також використовується клієнтськими програмами), перед виведенням результат бажано відфільтрувати. Найбільш корисними для користувача є такі елементи:

- `string` - назва поля (мітка)
- `help` - довідковий текст, якщо він є
- `type` - тип поля (щоб розуміти, які значення очікуються або які потрібно передавати при оновленні запису)

```python
models.execute_kw(db, uid, password, 'res.partner', 'fields_get', [], {'attributes': ['string', 'help', 'type']})
```

результат:

```
{
    "ean13": {
        "type": "char",
        "help": "BarCode",
        "string": "EAN13"
    },
    "property_account_position_id": {
        "type": "many2one",
        "help": "The fiscal position will determine taxes and accounts used for the partner.",
        "string": "Fiscal Position"
    },
    "signup_valid": {
        "type": "boolean",
        "help": "",
        "string": "Signup Token is Valid"
    },
    "date_localization": {
        "type": "date",
        "help": "",
        "string": "Geo Localization Date"
    },
    "ref_company_ids": {
        "type": "one2many",
        "help": "",
        "string": "Companies that refers to partner"
    },
    "sale_order_count": {
        "type": "integer",
        "help": "",
        "string": "# of Sales Order"
    },
    "purchase_order_count": {
        "type": "integer",
        "help": "",
        "string": "# of Purchase Order"
    },
```

## Пошук і читання

Оскільки це дуже поширена операція, в Odoo є скорочений метод `search_read()`, який, як випливає з назви, еквівалентний виклику `search()`, після якого виконується `read()`. Однак він дозволяє уникнути двох окремих запитів і зберігання списку `id`.

Його аргументи подібні до аргументів `search()`, але він також може приймати список полів (як і `read()`). Якщо список полів не заданий, будуть отримані всі поля знайдених записів.

```python
models.execute_kw(db, uid, password, 'res.partner', 'search_read', [[['is_company', '=', True]]], {'fields': ['name', 'country_id', 'comment'], 'limit': 5})
```

результат:

```
[
    {
        "comment": false,
        "country_id": [ 21, "Belgium" ],
        "id": 7,
        "name": "Agrolait"
    },
    {
        "comment": false,
        "country_id": [ 76, "France" ],
        "id": 18,
        "name": "Axelor"
    },
    {
        "comment": false,
        "country_id": [ 233, "United Kingdom" ],
        "id": 12,
        "name": "Bank Wealthy and sons"
    },
    {
        "comment": false,
        "country_id": [ 105, "India" ],
        "id": 14,
        "name": "Best Designers"
    },
    {
        "comment": false,
        "country_id": [ 76, "France" ],
        "id": 17,
        "name": "Camptocamp"
    }
]
```

## Створення записів

Записи моделі створюються за допомогою методу `create()`. Цей метод створює один запис і повертає його ідентифікатор у базі даних. Метод `create()` приймає словник відповідності полів і значень, який використовується для ініціалізації запису. Для будь-якого поля, яке має значення за замовчуванням і не задане у переданому словнику, буде використане значення за замовчуванням.

```python
id = models.execute_kw(db, uid, password, 'res.partner', 'create', [{'name': "New Partner"}])
```

```
78
```

Попередження. Хоча більшість типів значень відповідають очікуваним (ціле число для `Integer`, `string` для `Char` або `Text`),

- поля `Date`, `Datetime` та `Binary` використовують `string` значення
- поля `One2many` та `Many2many` використовують спеціальний командний протокол, описаний у документації до методу `write`.

## Оновлення записів

Записи можна оновлювати за допомогою методу `write()`. Він приймає список записів для оновлення та словник полів із новими значеннями, подібно до `create()`. Можна оновлювати кілька записів одночасно, але всі вони отримають однакові значення для полів, які змінюються. Виконувати «обчислювані» оновлення (коли нове значення залежить від наявного значення запису) неможливо.

```python
models.execute_kw(db, uid, password, 'res.partner', 'write', [[id], {'name': "Newer partner"}])
# get record name after having changed it
models.execute_kw(db, uid, password, 'res.partner', 'read', [[id], ['display_name']])
```

```
[[78, "Newer partner"]]
```

## Видалення записів

Записи можна видаляти пакетно, передавши їх ідентифікатори методу unlink().

```python
models.execute_kw(db, uid, password, 'res.partner', 'unlink', [[id]])
# check if the deleted record is still in the database
models.execute_kw(db, uid, password, 'res.partner', 'search', [[['id', '=', id]]])
```

## Інспекція та інтроспекція

Раніше ми використовували `fields_get()` для запиту інформації про модель і з самого початку працювали з довільною моделлю. Однак більшість метаданих моделей в Odoo зберігається у кількох метамоделях, які дозволяють як запитувати інформацію про систему, так і змінювати моделі та поля (з певними обмеженнями) безпосередньо через XML-RPC.

`ir.model` - Надає інформацію про моделі Odoo через свої поля.

`name` - людинозрозумілий опис моделі

`model` - назва кожної моделі в системі

`state` - показує, чи була модель створена в коді Python (base) або шляхом створення запису `ir.model` (manual)

`field_id` - список полів моделі через зв’язок `One2many` з `ir.model.fields`

`view_ids` - зв’язок One2many з архітектурами представлень (View), визначених для цієї моделі

`access_ids` - зв’язок One2many з правами доступу, встановленими для моделі

Модель `ir.model` можна використовувати для:

- отримання списку встановлених у системі моделей (як попередню умову для операцій з моделлю або для дослідження вмісту системи)
- отримання інформації про конкретну модель (зазвичай шляхом перегляду її полів)
- динамічного створення нових моделей через RPC

Важливо

- Назви користувацьких моделей повинні починатися з `x_`.
- Поле `state` повинно бути задане і мати значення manual, інакше модель не буде завантажена.
- До користувацької моделі неможливо додати нові методи, можна додавати лише поля.

Приклад. Користувацька модель спочатку міститиме лише «вбудовані» поля, які доступні у всіх моделях.

```python
models.execute_kw(db, uid, password, 'ir.model', 'create', [{
    'name': "Custom Model",
    'model': "x_custom_model",
    'state': 'manual',
}])
models.execute_kw(db, uid, password, 'x_custom_model', 'fields_get', [], {'attributes': ['string', 'help', 'type']})
```

```
{
    "create_uid": {
        "type": "many2one",
        "string": "Created by"
    },
    "create_date": {
        "type": "datetime",
        "string": "Created on"
    },
    "__last_update": {
        "type": "datetime",
        "string": "Last Modified on"
    },
    "write_uid": {
        "type": "many2one",
        "string": "Last Updated by"
    },
    "write_date": {
        "type": "datetime",
        "string": "Last Updated on"
    },
    "display_name": {
        "type": "char",
        "string": "Display Name"
    },
    "id": {
        "type": "integer",
        "string": "Id"
    }
}
```

`ir.model.fields` - Надає інформацію про поля моделей Odoo і дозволяє додавати користувацькі поля без використання Python-коду.

`model_id` - зв’язок Many2one з ir.model, до якої належить поле

`name` - технічна назва поля (використовується у `read` або `write`)

`field_description` - зрозуміла для користувача назва поля (наприклад `string` у `fields_get`)

`ttype` - тип поля, яке потрібно створити

`state` - показує, чи було поле створене в Python-коді (base) або через ir.model.fields (manual)

`required`, `readonly`, `translate` - вмикають відповідні властивості поля

`groups` - контроль доступу на рівні поля, зв’язок Many2many з `res.groups`

`selection`, `size`, `on_delete`, `relation`, `relation_field`, `domain` - властивості та налаштування, специфічні для типу поля; деталі наведені у документації щодо полів

Важливо

- Як і у випадку з користувацькими моделями, активними стають лише нові поля, створені зі значенням `state="manual"`.
- Обчислювані поля (computed fields) не можна додавати через `ir.model.fields`; деяку метаінформацію поля (значення за замовчуванням, onchange) також неможливо задати таким способом.

```python
id = models.execute_kw(db, uid, password, 'ir.model', 'create', [{
    'name': "Custom Model",
    'model': "x_custom",
    'state': 'manual',
}])
models.execute_kw(db, uid, password, 'ir.model.fields', 'create', [{
    'model_id': id,
    'name': 'x_name',
    'ttype': 'char',
    'state': 'manual',
    'required': True,
}])
record_id = models.execute_kw(db, uid, password, 'x_custom', 'create', [{'x_name': "test record"}])
models.execute_kw(db, uid, password, 'x_custom', 'read', [[record_id]])
```

```
[
    {
        "create_uid": [1, "Administrator"],
        "x_name": "test record",
        "__last_update": "2014-11-12 16:32:13",
        "write_uid": [1, "Administrator"],
        "write_date": "2014-11-12 16:32:13",
        "create_date": "2014-11-12 16:32:13",
        "id": 1,
        "display_name": "test record"
    }
]
```



## Джерела

1. 


## Автори


Теоретичне заняття розробив [Олександр Пупена](https://github.com/pupenasan). 

## Feedback

Якщо Ви хочете залишити коментар у Вас є наступні варіанти:

- [Обговорення у WhatsApp](https://chat.whatsapp.com/BRbPAQrE1s7BwCLtNtMoqN)
- [Обговорення в Телеграм](https://t.me/+GA2smCKs5QU1MWMy)
- [Група у Фейсбуці](https://www.facebook.com/groups/asu.in.ua)

Про проект і можливість допомогти проекту написано [тут](https://asu-in-ua.github.io/atpv/)
