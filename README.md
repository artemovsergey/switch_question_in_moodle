# switch_question_in_moodle
- Установите ruby <a href = "https://rubyinstaller.org/downloads/">installer</a> <br>
- Установите фреймворк Sinatra <code> gem install sinatra </code><br> в командной строке
- Обновите библиотеки <code> bundle install</code> в папке проекта <br> в командной строке
- Cкачайте <a href = "https://github.com/mozilla/geckodriver/releases"> вебдрайвер FireFox </a> для вашей системы. Положите драйвер в bin
- Папку bin на диск C <br>
- Запустите проект <code> ruby switch_question.rb </code> <br> в командной строке
- В адресной строке <code> http://localhost:4567/ </code> <br>

<br>

<image src = "https://github.com/artemovsergey/switch_question_in_moodle/blob/main/image/%D0%A1%D0%BA%D1%80%D0%B8%D0%BD%D1%88%D0%BE%D1%82%202021-01-15%2019.50.27.png"><image>

## Данные

1. Логин Moodle
2. Пароль Moodle
3. Ссылка на страницу редактирования теста. Например, http://kcdo.stvcc.ru/mod/quiz/edit.php?cmid=18163 <br>
   <a href = "https://github.com/artemovsergey/switch_question_in_moodle/blob/main/test_question.txt"></a>
4. Включение интерактивного режима
5. Выбор файла теста из тестовой системы колледжа в кодировке UTF-8 (Cохранить как -> UTF-8). Тип вопросов в тестовой системе колледжа 3 и 1 <br>
   <a href = "https://github.com/artemovsergey/switch_question_in_moodle/blob/main/test_question.txt"></a>

## Как это работает
При включении интерактивного режима можно посмотреть алгоритм действий для переноса вопросов
