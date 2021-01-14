require 'sinatra'
#require 'sinatra/reloader'
require 'selenium-webdriver'


    get '/' do

        erb :index
    end

    post '/' do

      
      @login = params[:login]
      @password = params[:password]
      @link = params[:link]
      @tempfile_path = params[:file][:tempfile].path


      NAME_QUESTION = "Вопрос"
   
      options = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
      driver = Selenium::WebDriver.for :firefox, options: options #,profile: profile, 

      begin


         	# Disable javascript for Firefox

            puts "Отключаем javascript в firefox"

            driver.get("about:config");
            sleep 1
            driver.find_element(id: 'warningButton').click
            sleep 1
            driver.action.send_keys("javascript.enabled").perform
            sleep 1
            driver.action.send_keys(:tab).perform
            sleep 1
            driver.action.send_keys(:return).perform
            sleep 1
            driver.get("http://kcdo.stvcc.ru")


            	# Log in

            puts "Авторизация"

            def signin(name,password,driver)
               driver.find_element(link: 'Вход').click
               driver.find_element(name: 'username').send_keys name
               driver.find_element(name: 'password').send_keys password
               driver.find_element(name: 'rememberusername').click
            end

           
            signin(@login,@password,driver)
            driver.find_element(id: 'loginbtn').click



            puts "Переходим на страницу редактировния теста"
            
            # Cсылка на конкретный тест
            #link_path = 'http://kcdo.stvcc.ru/mod/quiz/edit.php?cmid=18163'
            
            link_path = @link

            driver.navigate.to link_path

            # Чтение файла теста в кодировке UTF-8

            file_path = @tempfile_path
            
            f = File.new(file_path,'r:UTF-8')
               content = f.read.split('##')[1..-1]
            f.close

            for question in content


               text_question = question.split(/\n/)[1]
               answers = question.split(/\n/)[3..-1]
              
              # Type action for type question
        
              # Добавление вопроса
        
              element = driver.find_element(:xpath,'//input[@type="submit" and @value = "Добавить вопрос..."]')
              element.click
        
              def multichoice(driver,text_question,answers)
                 #
                 # Выбираем множественный выбор
                 driver.find_element(:xpath,'//input[@id="qtype_multichoice"]').click
                 # или 
                 # element = driver.find_element(:xpath,'//input[@id="	qtype_shortanswer"]').click
        
                 puts "Нажимаем далее"
                 driver.find_element(:xpath,'//input[@id="chooseqtype_submit"]').click
        
                 puts "Название вопроса"	
                 driver.find_element(name: 'name').send_keys NAME_QUESTION
        
                 puts "Текст вопроса"
                 driver.find_element(:xpath,'//textarea[@id="id_questiontext" and @name = "questiontext[text]"]').send_keys text_question
        
                 puts "Опция: не нумеровать"
        
                 select_element = driver.find_element(:xpath,'//select[@id="id_answernumbering" and @name = "answernumbering"]')
                    
                    select_element.find_elements( :tag_name => "option" ).find do |option|
                      option.text == "Не нумеровать"
                    end.click
        
                 puts "Вариант ответа 1"
        
                 driver.find_element(:xpath,'//textarea[@id="id_answer_0" and @name = "answer[0][text]"]').send_keys answers[0]
                 
                 select_element = driver.find_element(:xpath,'//select[@id="id_fraction_0" and @name = "fraction[0]"]')
                    
                    select_element.find_elements( :tag_name => "option" ).find do |option|
                      option.text == "100%"
                    end.click
        
                 puts "Вариант ответа 2"
                 
                 driver.find_element(:xpath,'//textarea[@id="id_answer_1" and @name = "answer[1][text]"]').send_keys answers[1]
        
                 puts "Вариант ответа 3"
                 
                 driver.find_element(:xpath,'//textarea[@id="id_answer_2" and @name = "answer[2][text]"]').send_keys answers[2]
        
                 puts "Вариант ответа 4"
                 
                 driver.find_element(:xpath,'//textarea[@id="id_answer_3" and @name = "answer[3][text]"]').send_keys answers[3]
        
                 if answers[4]
                    puts "Вариант ответа 5"			
                    driver.find_element(:xpath,'//textarea[@id="id_answer_4" and @name = "answer[4][text]"]').send_keys answers[4]
                 end
        
                 puts "Сохранение"
        
                 driver.find_element(:xpath,'//input[@id="id_submitbutton" and @name = "submitbutton"]').click
        
              end
        
              def shortanswer(driver,text_question,answers)
                 
                 # Выбираем короткий ответ
                 driver.find_element(:xpath,'//input[@id="qtype_shortanswer"]').click
        
                 puts "Нажимаем далее"
                 driver.find_element(:xpath,'//input[@id="chooseqtype_submit"]').click
        
                 puts "Название вопроса"	
                 driver.find_element(name: 'name').send_keys NAME_QUESTION
        
                 puts "Текст вопроса"
                 driver.find_element(:xpath,'//textarea[@id="id_questiontext" and @name = "questiontext[text]"]').send_keys text_question
        
                 # puts "Опция: не нумеровать"
        
                 # select_element = driver.find_element(:xpath,'//select[@id="id_answernumbering" and @name = "answernumbering"]')
                    
                 # 	select_element.find_elements( :tag_name => "option" ).find do |option|
                 # 	  option.text == "Не нумеровать"
                 # 	end.click
        
                 puts "Вариант ответа 1"
        
                 driver.find_element(:xpath,'//input[@id="id_answer_0" and @name = "answer[0]"]').send_keys answers[0]
                 
                 select_element = driver.find_element(:xpath,'//select[@id="id_fraction_0" and @name = "fraction[0]"]')
                    
                    select_element.find_elements( :tag_name => "option" ).find do |option|
                      option.text == "100%"
                    end.click
        
                 puts "Сохранение"
        
                 driver.find_element(:xpath,'//input[@id="id_submitbutton" and @name = "submitbutton"]').click
        
              end
        
              multichoice(driver,text_question,answers) if question.split(/\n/)[0].split("::")[1] == "3"
              shortanswer(driver,text_question,answers) if question.split(/\n/)[0].split("::")[1] == "1"
        
        
           end

	
      ensure
          sleep 1
          driver.quit
      end






      erb :post_action
    end  


