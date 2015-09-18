Python, Lua and C quiz application written in Lapis
===================================================

http://kodomoquiz.tk

Dependencies
------------

 - postgres or mysql
 - openresty
 - lapis
 - lua module "date" (from luarocks)
 - lua module "mo" (from luarocks)
 - lua module "yaml" (from luarocks)

Как добавить свой тест
----------------------

В этой инструкции будем новый тест называть `testName`

Идентификаторы тестов, вопросов и т.п. должны быть человеческими:
без пробелов, русских букв и всякого такого.

 - Склонировать репозиторий:
   `git clone https://github.com/starius/kodomoquiz`
 - `cd kodomoquiz`
 - сделать файл `quiz/testName.yml` с тестом. Пример и краткое описание
    формата см. в файле `quiz/test2.yml`
 - [проверить](http://www.yamllint.com/) файл на валидность синтаксиса YAML.
 - добавить имя теста в соответствующее место файла `quiz/groups.lua`.
   Например, в секцию Bioinf:
   ```lua
   {'Bioinf', group {
        'bioinf1',
        'bioinf2',
        ...
        'testName', -- вот такую строчку надо добавить
   }
   ```
 - уведомить гит о новом файле: `git add quiz/testName.yml`
 - сделать коммит:
   `git commit quiz/testName.yml quiz/testName.yml -m 'new quiz testName'`
 - отправить коммит на гитхаб: `git push`
 - зайти на http://kodomoquiz.tk/ и нажать кнопку "Update code"
 - добавить колонки `quiz.testName` и следующую за ней `deadline`
   в ведомость
 - протестировать quiz пару раз и убедиться, что оценки "прилетают"
   в ведомость
