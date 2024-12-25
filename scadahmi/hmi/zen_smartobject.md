[<- До підрозділу](README.md)

# Smart Object в SCADA zenon

Смарт-об’єкти дозволяють об’єднувати складний вміст в один пакет. Цими конфігураціями можна обмінюватися між комп’ютерами та проектами zenon. Шаблон смарт-об’єкта можна використовувати будь-яку кількість разів у проекті. Параметри цих екземплярів, розумних об’єктів, можна встановити по-різному. Створення конфігурацій драйвера за допомогою екземплярів Smart Object неможливе. Розробник проекту шаблону смарт-об’єкта може випустити окремі властивості для конфігурації. Це робить налаштування вмісту в zenon швидким, ефективним і дуже простим.

Розумні об'єкти пропонують:

- Легка взаємозамінність конфігурацій за допомогою імпорту та експорту.
- Спрощена конфігурація, оскільки зі смарт-об’єктом пов’язані лише настроювані властивості.
- Модифікація на основі діалогу для оновлення існуючих смарт-об’єктів і відображення змінних.

Engineering Studio пропонує два інтерфейси користувача для налаштування:

- Закладка з шаблоном смарт-об’єктів для конфігурації смарт-об’єктів.
- Вузол Smart Objects у дереві проекту для використання та налаштування в проектах, службах і екранах zenon.

Починаючи з версії 14 і вище, смарт-об’єкти підтримують розподілену інженерію. 

Шаблони смарт-об’єктів застосовуються до наявної конфігурації у вузлі проекту в Engineering Studio. Для цього налаштовуються розумні об'єкти. Смарт-об’єкт завжди базується на шаблоні смарт-об’єкта.

Ви можете знайти інформацію про створення шаблонів смарт-об’єктів у вузлі Конфігурація шаблонів смарт-об’єктів.

Шаблони смарт-об’єктів керуються та налаштовуються в окремій вкладці менеджера проектів. Це подання містить інженерне середовище для шаблонів смарт-об’єктів. Шаблони створюються та керуються в цьому поданні окремо від конфігурації в Engineering Studio. Зовнішній вигляд базується на дереві проекту, але містить лише ті служби та функції, які необхідні для створення шаблону смарт-об’єкта.

![image-20241219152024970](C:\san\народн посібн атпв\gitver\scadahmi\hmi\mediazen\image-20241219152024970.png)

Вигляд інженерного середовища шаблону смарт-об’єкта розділено на такі частини:

- Огляд шаблонів смарт-об’єктів. Усі існуючі шаблони смарт-об’єктів перераховуються та керуються у вигляді дерева.

- Головне вікно
  - Інженерне середовище шаблонів смарт-об'єктів. У другому перегляді дерева показано всі служби, які підтримують конфігурації для шаблону смарт-об’єкта.
  - Випущені властивості. У цьому поданні керуються властивості zenon. Лише налаштовані тут властивості доступні користувачеві смарт-об’єкта для параметризації.

- опис. Додаткова визначена користувачем інформація для шаблону смарт-об’єкта.

Smart Object references

У цьому вузлі ви можете пов’язати шаблон смарт-об’єкта з вмістом конфігурації одного або кількох інших шаблонів смарт-об’єкта. Це дозволяє виконувати вкладені, нерекурсивні конфігурації. Шаблони смарт-об’єктів застосовують увесь вміст тих шаблонів смарт-об’єктів, для яких було налаштовано посилання.



Коли шаблон смарт-об’єкта налаштовано, ви можете означити властивості, параметри яких повинен налаштувати користувач смарт-об’єкта. Мета повинна полягати в тому, щоб користувач розумного об’єкта потребував мінімального рівня складності та конфігурації. Це передбачає надання для параметризації лише тих властивостей, які абсолютно необхідні для використання в смарт-об’єкті. Випущені властивості залежать від досвіду користувача смарт-об’єкта.

Таким чином, творець шаблону смарт-об’єкта повинен виконати наступні кроки налаштування:

- Властивості випуску - Конфігурація властивостей, доступних користувачеві смарт-об’єкта.
- Властивості об’єднання - Об’єднання кількох властивостей в одну конфігуровану властивість смарт-об’єкта.
- Властивості структури - Організація властивостей у сегменти/групи.



### Release properties

Випущені властивості можуть бути налаштовані користувачем у смарт-об’єкті. Неопубліковані властивості шаблону смарт-об’єкта більше не можна змінювати як компонент смарт-об’єкта. Ці властивості застосовують налаштований шаблон смарт-об’єкта

Щоб звільнити властивість для конфігурації в смарт-об’єкті, виконайте такі дії. Виберіть такий запис, як «Змінні», у дереві проекту вибраного шаблону смарт-об’єкта. Клацніть у детальному перегляді (раніше створеної) змінної шаблону смарт-об’єкта.

 Налаштуйте властивості змінної. Звільніть ті властивості, які повинен налаштувати користувач смарт-об’єкта. Для цього клацніть потрібну властивість у відповідній групі властивостей у вікні властивостей. Застосуйте цю властивість в області звільнених властивостей: Для цього перетягніть назви властивостей у список увімкнених властивостей шаблону смарт-об’єкта.

![image-20241219172609705](C:\san\народн посібн атпв\gitver\scadahmi\hmi\mediazen\image-20241219172609705.png)

Клацніть назви властивостей і натисніть кнопку Вивільнити властивість на панелі інструментів вікна властивостей. Відкрийте контекстне меню властивості, яку потрібно звільнити, і виберіть параметр Звільнити властивість. Необов’язково: назвіть звільнену властивість. Для цього повільно клацніть на запис у стовпчику Ім'я. Осередок буде звільнено для редагування. Перейменуйте звільнену властивість.
Це ім’я відображається у вікні властивостей смарт-об’єкта під час налаштування.

Завдяки функції багаторазового вибору в детальному списку дерева проектів шаблонів смарт-об’єктів ви можете застосувати ту саму властивість для всіх виділених елементів лише одним клацанням миші. Приклад: конфігурація шаблону смарт-об’єкта містить п’ять змінних. Виділення усі п’ять змінних у детальному списку. Клацніть властивість Identification у вікні властивостей. Застосуйте цю властивість у списку дозволених властивостей. Властивість включена окремо в список дозволених властивостей для кожної змінної. Це означає, що в списку звільнених властивостей перелічено п’ять записів для звільненої властивості: для кожної змінної відповідна властивість.

### Release properties for symbols

![image-20241219181737378](C:\san\народн посібн атпв\gitver\scadahmi\hmi\mediazen\image-20241219181737378.png)

Властивості елементів символу (такі як ширина та висота елементів екрана) не можна оприлюднити безпосередньо в шаблоні смарт-об’єкта. Ці властивості потрібно спочатку застосувати у звільнених властивостях символу. Згодом ці звільнені властивості символу можна перетягнути й опустити на звільнені властивості шаблону смарт-об’єкта.

Відобразити символ у смарт-об’єкті.

Під час налаштування символу в шаблоні смарт-об’єкта можна визначити, чи буде символ видимим для користувача, коли він використовується в смарт-об’єкті. Для цього налаштуйте відповідну властивість Display in Smart Object list list.

Випущені властивості символу завжди видимі та доступні для налаштування для користувача.

Приклад 1: Активовано властивість «Відображати в списку смарт-об’єктів»:

![image-20241219181809761](C:\san\народн посібн атпв\gitver\scadahmi\hmi\mediazen\image-20241219181809761.png)

Example 2:Display in Smart Object list property deactivated

![image-20241219181844863](C:\san\народн посібн атпв\gitver\scadahmi\hmi\mediazen\image-20241219181844863.png)

Merge and combine released properties

Several properties with the same configuration content can be merged for the configuration of a smart object. This means that only one property is available for the parameterization in the smart object. All the elements of the properties group are assigned the same value during parameterization.

When parameterizing a smart object template, this is done by creating a group. The created group can only contain properties with the same configuration content.

Example:

- Properties for the graphic display
- of a property of several zenon elements: Identification of several configured variables.

### Об’єднайте та комбінуйте звільнені властивості. 

Кілька властивостей з однаковим вмістом конфігурації можна об’єднати для конфігурації смарт-об’єкта. Це означає, що лише одна властивість доступна для параметризації в смарт-об’єкті. Під час параметризації всім елементам групи властивостей присвоюється однакове значення.  Параметризуючи шаблон смарт-об’єкта, це робиться шляхом створення групи. Створена група може містити лише властивості з однаковим вмістом конфігурації.

приклад:

— Властивості для графічного відображення. властивості кількох елементів zenon: Ідентифікація кількох налаштованих змінних.

![image-20241219181916759](C:\san\народн посібн атпв\gitver\scadahmi\hmi\mediazen\image-20241219181916759.png)

Follow the following steps to merge several properties for the parameterization in a smart object into one group:

1. Switch to the engineering environment of the smart object templates.

   1. To do this, click the Smart Object templatestab in the project manager.

2. Select a smart object template in the tree view.
   This displays the engineering environment for the smart object template.

3. Select an entry such as Variables in the project tree of the selected smart object template.

4. Create a new group.

   1. To do this, select from the list of released properties the entry of a property you wish to merge with other properties in a group.

   2. In the toolbar, select the symbol or the New group entry in the context menu.

      A new entry is created in the list. This entry is named Group by default. The new entry is displayed as a node in the list and, as a sub-entry, contains the previously selected property.

5. You can drag&drop further properties to add them to the structure of the group. To do this, drag the selected entry onto the row of the group.

   Note: This means you can select several properties in the List of released properties and drag & drop them onto the group in one move.

6. Optional: Give the newly created group a name.

   1. To do so, click slowly the entry in the Name column. The cell will be released for editing.

   2. Rename the group.
      This name is displayed in the properties window of the smart object during parameterization.

      Released, merged properties groups (Group type) and individual properties can be organized in group boxes (Node type). In this way, a group can be a component of a node. However, a node can never be part of another node.

Remove elements from the group - undo merge

Follow the following steps to remove one or several elements from the group of merged properties:

1. In the list of released properties, select the entry for an existing group.

2. Click on the [+] next to the entry. The entry is expanded.
   All the entries contained within are listed as subentries.

3. Drag&drop the entry onto the end of the list of released properties. The selected entry is removed from the group. Please pay attention to the mouse cursor during this step.

   Note: This means you can select several properties and use drag & drop to remove them from the group in one move.

4. If a configured group no longer contains any entries, the group will be deleted from the List of released properties

Structuring of released properties

Depending on the scope and use case, a smart object template can have a large number of released properties. To keep things manageable for the user, properties can be merged into nodes for display. Theses nodes are displayed in the smart object as a group box with all the released properties contained within it. The name of the group field corresponds with the name of the node in the list of released properties of the smart object template.

When structuring, related properties can be displayed separately in one node:All the properties that are parameterized for the configuration of a limit value.All the properties that should be parameterized by the user in the smart object for setting a limit value.

![image-20241219181953903](C:\san\народн посібн атпв\gitver\scadahmi\hmi\mediazen\image-20241219181953903.png)

Follow the following steps to display several properties for the parameterization in a smart object as a group box:

1. Switch to the engineering environment of the smart object templates.

   1. To do this, click the Smart Object templatestab in the project manager.

2. Select a smart object template in the tree view.
   This displays the engineering environment for the smart object template.

3. Select an entry such as Variables in the project tree of the selected smart object template.

4. Create a new node.

   1. In the toolbar, select the symbol or the New node entry in the context menu.

      A new entry is created in the list. This entry is named Group box by default.

5. You can drag&drop properties to add them to the structure of the node. To do this, drag the selected entry onto the row of the node.

   Note: This means you can select several properties in the List of released properties and drag&drop them onto the node in one move.

6. Optional: Give the node a name.

   1. To do so, click slowly the entry in the Name column. The cell will be released for editing.

   2. Rename the node.
      This name is displayed as a header in the properties window of the smart object during parameterization.

      Released, merged properties groups (Group type) and individual properties can be organized in group boxes (Node type). In this way, a group can be a component of a node. However, a node can never be part of another node.

Undo structuring

Follow the following steps to cancel the structuring for one or several properties:

1. In the List of released properties, select the entry for an existing node.

2. Click on the [+] next to the entry. The entry is expanded. All the entries contained within are listed as subentries.

3. Drag&drop the entry onto the end of the list. The selected entry is removed from the node. Please pay attention to the mouse cursor during this step.

   Note: This means you can select several properties and use drag&drop to remove them from the node in one move.

4. If a configured node no longer contains any entries, the entry is retained in the List of released properties.

Reference smart object templates

![image-20241219182025676](C:\san\народн посібн атпв\gitver\scadahmi\hmi\mediazen\image-20241219182025676.png)

Follow the following steps to create a reference to an existing smart object template:

1. Switch to the engineering environment of the smart object templates.

   1. To do this, click the Smart Object templatestab in the project manager.

2. Select a smart object template in the tree view.
   This displays the engineering environment for the smart object template.

3. Select the Smart Object references entry in the tree view of the selected smart object template.

4. Create a new reference.

   1. In the toolbar, select the Reference smart objectsymbol or the New reference entry in the context menu.

      The [reference smart object](#showid/DDFEC1EB1FD1A2891A20ECF5F3874EF7CE06B889D73510C0AB01356AA249DF04) dialog is opened.

   2. Select an existing smart object template from the Smart object templates list as the basis for the reference.

   3. Give the new reference to be created a name by entering a name in the Name for new smart objectinput field.

   4. Confirm your configuration by clicking on the Create button.

5. The reference is displayed in the Smart Object references node in the detail view of the smart object template.

   Clicking on the reference displays the released properties in the properties window. This information is applied by the configuration of the linked smart object template.

   The released properties of the referenced smart object template must be released again before they can be configured in the smart object. Released properties of referenced smart object templates are not automatically available for configuration in the current smart object.



Create a description for a smart object template

![image-20241219182100830](C:\san\народн посібн атпв\gitver\scadahmi\hmi\mediazen\image-20241219182100830.png)

In the case of a smart object template, a specific description can be saved in .HTML file format for the user. This information is displayed in the Descriptiontab. The user will see this description when creating a smart object and in the management dialog. When a smart object template is created for the first time, it does not have a description.

When a smart object template is exported, an already existing description is included in the .SO file. Thus, it is available automatically to the user when importing the template.

Follow the following steps to create a description for a smart object template:

1. Create a description for the smart object template in a .HTML file format.
   Attention: The (first) page must be named index.htm.

   For this, you can use any HTML editor, create simple HTML files from Word or create the HTML file in a text editor. Save your files.

2. Identify the GUID of the smart object template:

   1. Switch to the Smart Object templatestab in the zenon project manager.
   2. Select the smart object template in the project manager for which you want to add the description. In the properties, see the GUID.
      Make a note of this GUID, for example, by taking a screenshot.

3. Open the storage location of the smart object template:

   1. Open the folder C:\ProgramData\COPA-DATA\SQL2019\[Project GUID]\FILES\zenon\system\SmartObjects\[Smart Object template GUID]\Description.
   2. Select the active zenon project in the project tree. To do this, click the Project treetab in the project manager and highlight the main node of the project.
   3. Press the Ctrl+Alt+Ekeyboard shortcut. + Alt + E.The project storage folder opens.
   4. Go to the system and SmartObjects subfolders. All configured smart object templates are displayed in the content area. Each folder has the name of the GUID of the smart object template.
   5. Open the Description folder within the smart object template folder.

4. Copy the previously created files for the information of the smart object templates in the corresponding language folder.

   Each language folder corresponds to the available display language of Engineering Studio. This allows you to provide the user with information in the language in which the user is performing the configuration.
   Example: If the Engineering Studio is opened in Japanese, for example, and the respective language folder of the Smart Object Template (JAPANESE) does not contain any content, the content of the ENGLISH folder will be displayed automatically in Engineering Studio.

   | If you create a new version of an existing smart object template, a change history will be added to your description. This makes it easier to distinguish between different versions of a smart object template. |
   | ------------------------------------------------------------ |
   | Descriptions can also be for password-protected Smart Object Templates to be created. |



![image-20241219114350035](C:\san\народн посібн атпв\gitver\scadahmi\hmi\mediazen\image-20241219114350035.png)

![image-20241219114520625](C:\san\народн посібн атпв\gitver\scadahmi\hmi\mediazen\image-20241219114520625.png)

![image-20241219114539517](C:\san\народн посібн атпв\gitver\scadahmi\hmi\mediazen\image-20241219114539517.png)



![image-20241219113816247](C:\san\народн посібн атпв\gitver\scadahmi\hmi\mediazen\image-20241219113816247.png)