# Als/Config

Config Manager Component.

---

Designed to simplify access to configuration data within applications. The configuration
data may come from a variety of formats supporting hierarchical data storage. Currently
provides adapters that read configuration data stored in INI, JSON and XML files.

---

## Пример использования

```ruby
# Создаем объект класса 'Als/Config':
$config[^Als/Config::create[]]


# Читаем конфиги из файлов:
^config.read[/path/to/config_ini.ini]
^config.read[/path/to/config_xml.xml]
^config.read[/path/to/config_json.json]

# Тпереь нам доступны конфиги по ключам из названий файлов:
$ini[$config.config_ini]
$xml[$config.config_xml]
$json[$config.config_json]

# Так же при чтение файлов, мы можем указать ключ, по которому данные будут доступны:
^config.read[cache;/path/to/cache.ini]
#--> $config.cache
```

---

## Параметры создания объекта

```ruby
# При создании объекта класса 'Als/Config', мы можем указать папку с конфигами:
$config[^Als/Config::create[
	$.root[/path/to/configs]
]]

# Теперь при чтении конфигов, нам не надо указывать полный путь к файлу с конфигом:
^config.read[database.xml]


# Так, же при создании объекта класса 'Als/Config', мы можем указать список
# конфигов, которые будут автоматически загружены во время создания экземпляра класса:
#
# Аргумент $.configs[] передается в виде хеша, в котором:
#  'ключ'     - это ключ по которому будут доступны данные конфига в объекте класса
#  'значение' - путь к файлу с конфигурационными данными
$config[^Als/Config::create[
	$.configs[
		$.cache[cache.ini]
		$.database[database.xml]
	]
]]
```

---

## Методы доступа к конфигурационным данным

```ruby
# Создаем объект класса 'Als/Config':
$config[^Als/Config::create[]]

# Читам конфигурационные данные из файла 'database.json', со следующим содержимым:
#  {
#    "debug": true,
#    "cache": {
#       "path": "/path/to/database/cache"
#    }
#  }
^config.read[db;/path/to/database.json]

# Теперь мы можем получать конфигурационные данные, обращаясь к объекту '$config', как к хешу:
$debug($config.db.debug)

# Так же мы можем воспользоваться методом '^get[]' (для разделения вложенности используются точки):
$path[^config.get[db.cache.path]]

# Если вызвать метод '^get[]' без аргументов, то он вернёт хеш со всеми ранее загруженными конфигами:
$configs[^config.get[]]
```
---

## Примеры конфигов

### Формат .ini

```ini
; некоторый комментарий
# комментарий в стиле Unix

# Значения без секции
param1=value1 ; иногда допускается комментарий к отдельному параметру
param2=value2

[section]
; комментарий о разделе
param1=section.value1 # иногда допускается комментарий к отдельному параметру
param2=section.value2

[section.subsection]
param1=section.subsection.value1
param2=section.subsection.value2

; иногда позволяется перечислять несколько значений через запятую
[section.subsection2]
param1=section.subsection2.value1
param2=section.subsection2.value2

[section.subsection2.subsection3]
param1=section.subsection2.subsection3.value1
param2=section.subsection2.subsection3.value2

; Иногда значения отсутствуют
[section.subsection2.subsection4]

[section.subsection2.subsection5]
param1=
param2=
```

### Формат .xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<config>
    <param1>value1</param1>
    <param2>value2</param2>

    <section>
        <param1>section.value1</param1>
        <param2>section.value2</param2>

        <subsection>
            <param1>section.subsection.value1</param1>
            <param2>section.subsection.value2</param2>
        </subsection>

        <subsection2>
            <param1>section.subsection2.value1</param1>
            <param2>section.subsection2.value2</param2>

            <subsection3>
                <param1>section.subsection2.subsection3.value1</param1>
                <param2>section.subsection2.subsection3.value2</param2>
            </subsection3>

            <subsection4></subsection4>

            <subsection5>
                <param1></param1>
                <param2></param2>
            </subsection5>
        </subsection2>
    </section>
</config>
```

### Формат .json

```json
{
  "param1": "value1",
  "param2": "value2",

  "section": {
    "param1": "section.value1",
    "param2": "section.value2",

    "subsection": {
      "param1": "section.subsection.value1",
      "param2": "section.subsection.value2"
    },

    "subsection2": {
      "param1": "section.subsection2.value1",
      "param2": "section.subsection2.value2",

      "subsection3": {
        "param1": "section.subsection2.subsection3.value1",
        "param2": "section.subsection2.subsection3.value2"
      },

      "subsection4": {},

      "subsection5": {
        "param1": "",
        "param2": ""
      }
    }
  }
}
```

---

## TODO

- Написать метод "@parse[]", что бы можно было нетолько загружать данные из файлов.
- Написать метод "@save[]", что бы можно было сохранять конфиги.
- Парсинг аттрибутов в XML, сейчас конфиги формата '.xml' парсятся без учете аттрибутов.

---

## References

- Questions to Leonid Knyazev <leonid@knyazev.me> | <n3o@design.ru>
- Bug reports and Feature requests to Issues.

---
