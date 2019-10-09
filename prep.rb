require 'sinatra'
#require 'sinatra/reloader'
require 'roo'


   get  '/todo' do
     erb :todo
   end

    get '/' do
        erb :index
    end

    post '/' do

        
            # require 'roo'  # в Gemfile
         
            DAYS = {"1" => "Понедельник","2" => "Вторник","3" => "Среда","4" => "Четверг",
                "5" => "Пятница","6" => "Суббота"}
        
            GROUPS = {
        
        
        
                # 1
                "ИП 190" =>"AF AG",
                "ИП 191" => "AH AI",
                "ИП 192" => "D E",
                "ИП 193" => "F G",
                "ИП 194" => "H I",
                "ИП 195" => "L M",
                "ИП 196" => "N O",
                "ИП 197" => "P Q",
        
                "М 192" => "R S",
                "М 193" => "T U",
        
                "Р 192" => "V W",
                "С 191" => "AJ AK",
                "С 192" => "X Y",
                "С 193" => "AB AC",
                "Т 192" => "AD AE",
        
        
                # 2
                "Т 182" => "BH BI",
                "С 183" => "BD BE",
                "С 182" => "BB BC",
                "Р 182" => "BF BG",
                "ИП 185" =>"AR AS",
                "ИП 184" =>"AP AQ",
                "ИП 183" =>"AN AO",
                "ИП 182" =>"AL AM",
                "М 183" => "AV AW",
                "М 182" => "AT AU",
                "М 181" => "AZ BA",
                "М 180" => "AX AY",
        
                #3
                "Т 172" => "CF CG",
                "С 173" => "CD CE",
                "С 172" => "CB CC",
                "Р 172" => "BZ CA",
                "П 174" => "BX BY",
                "П 173" => "BV BW",
                "П 172" => "BT BU",
                "М 172" => "BP BQ",
                "М 173" => "BR BS",
                "ИД 172" => "BN BO",
                "Б 172" => "BJ BK",
                "И 170" => "CJ CK",
                "И 171" => "CL CM",
                "С 171" => "CH CI",
        
                #4
                "Т 162" => "DD DE",
                "С 162" => "CZ DA",
                "СП 162" => "DB DG",
                "ИД 162" => "CN CO",
                "П 164" =>"CV CW",
                "П 163" => "CT CU",
                "П 162" => "CR CS",
                "М 162" => "CP CQ",
                "Р 162" => "CX CY",
        
             
            }
        
            file_xlsx_path ="public/data/1_19_20.xlsx"
        
            X = Roo::Excelx.new(file_xlsx_path)
            @info  = X

            def  create_group_learn(search_group)
        
                a = GROUPS[search_group].split[0]
                b = GROUPS[search_group].split[1]
         
            # Парсим данные по столбцам
        
            group_user = X.sheet(0).column(a)
            group_user_kabinet = X.sheet(0).column(b)
           
    
            group_all = []
            i = 0
            while i < group_user.size do
                group_all[i] = group_user[i].to_s + " " + group_user_kabinet[i].to_s
                i+=1
            end
    
            # удаляем первый элемент
            group_all = group_all[1..-1]
    
    
            # # группировка по номеру 24 элемента в ячейке
            group_all_sort = []
            i = 0
            while i <= group_all.size-1
                group_all_sort << group_all[i...i+24]
                i+=24
            end
    
        
            for day in 0..4
                i=0
                stack = []
                while i < group_all_sort[day].size - 1
                    stack << group_all_sort[day][i...i+4]
                    i+=4
                end
                group_all_sort[day] = stack
            end
    
            # удаляем пустые строки
            for day in 0..4
                for para in 0..5
                    
                    for elem in 0..3
                        group_all_sort[day][para].delete(group_all_sort[day][para][elem]) if group_all_sort[day][para][elem] == " "
                    end
    
                   
                end
            end
    
            # с понедельника по пятницу
            group_all_select = []
            for n in 0..4
              group_all_select << group_all_sort[n]
            end
    
            #    for day in 0..4
            # test = []
            #     for para in group_all_select[day]
    
            #         if para[1] != nil
            #           if para[1].include?("1") or para[1].include?("2") or para[1].include?("3") or para[1].include?("4")
            #             test << para[1]
            #           end
            #         end
            #     end
    
            #     for i in 0..test.size - 1
            #        test[i] = test[i].split(" ")
            #     end
    
            # #     # # удаляем Л
            # #     #  for elem in test
            # #     #     if elem != nil
            # #     #         for id in elem
            # #     #             elem.delete(id) if id == "Л"
            # #     #         end
            # #     #     end
            # #     # end
                 
            #     bufer_number = []
            #      bufer_teacher = []
    
            #     for i in 0..test.size - 1
            #       bufer_number << test[i][0]
            #       bufer_teacher << test[i][1].to_s + " " + test[i][2].to_s
            #     end
    
            #      # заменяем
    
            #     j = 0
            #     for para in group_all_select[day]
            #         if not para.empty? and para != nil
                        
            #             para.delete_at(1)
            #             para << bufer_number[j] 
            #             para << bufer_teacher[j] 
            #             j+=1
                        
            #         end
            #       end   
            #       end
          
    
            return  group_all_select
           
    
        end
    
        def create_teacher_learn(name_teacher)
     
             teacher = []
    
                # проходим по всем группам
                for name_group in GROUPS.keys
    
    
                    for k in 0..4  # проход по дням недели
                                 
                        number = 1
                         
    
                        for para in create_group_learn(name_group)[k]  # по парам
    
                            
                            if not para[1].nil?
                                if para[1].include?(name_teacher)
                                    teacher <<   number.to_s + "_" + DAYS[(k+1).to_s] + "_" + name_group + "_" + para[0] + "_" + para[1].to_s 
                                end
                            end
                            number+=1
                        end
                        
                       
                    end
    
                end
    
            # if not teacher.empty?
            #     return teacher
            # else
            #     return false
            # end
    
            return teacher #create_group_learn("ИП 192")[0][0][1].include?("Волошина")
    
        end
    
        def create_labs_learn(number_labs)
            
            labs = []
    
            # проходим по всем группам
            for name_group in GROUPS.keys
    
    
                for k in 0..4  # проход по дням недели
                             
                    number = 1
                     
    
                    for para in create_group_learn(name_group)[k]  # по парам
    
                        
                        if not para[1].nil?
                            if para[1].include?(number_labs)
                                labs <<   number.to_s + "_" + DAYS[(k+1).to_s] + "_" + name_group + "_" + para[0]+ "_" + para[1]
                            end
                        end
                        number+=1
                    end
                    
                   
                end
    
            end
    
            if not labs.empty?
                return labs
            else
                return false
            end
    
        end
    
        def main(str)
        
            if  GROUPS.include?(str)

                return "practika" if time_practik?(str)

                return create_group_learn(str)
            elsif /^[А-Яа-я]+$/ === str 
    
                return  prepare_for_battle( create_teacher_learn(str) )
                #return  create_teacher_learn(str)
    
            elsif  /^([0-4]){1,3}$*/ === str 
    
                return  prepare_for_battle( create_labs_learn(str) )
    
            else
                return false
            end
    
        end
    
    # ["2 КУРС П 174 Четверг 3 пара_Администрир. Unix-подобных систем**Капшук С.В._202Л", "2 КУРС П 173 Четверг 4 пара_Администрир. Unix-подобных систем**Капшук С.В._202Л", "2 КУРС П 172 Четверг 2 пара_Администрир. Unix-подобных систем**Капшук С.В._202Л"]
    
            
    def prepare_for_battle(s)
        
        new_s = []
        for day in ["Понедельник","Вторник","Среда","Четверг","Пятница"]
    
            temp_s = []
            for i in s
                temp_s << i if i.include?(day)
            end
    
            new_s << temp_s
    
        end
        
        # for arr in new_s
    
        #     for i in 0..arr.size
        #         arr[i] = arr[i].split("_")  if not arr[i].nil?
        #         arr[i].delete_at(0) if not arr[i].nil?
        #         arr[i].delete_at(1) if not arr[i].nil?
        #         arr[i][1] = arr[i][1] + ' ' + arr[i][0] if not arr[i].nil?
        #         arr[i].delete_at(0) if not arr[i].nil?
        #         arr[i] = arr[i].join("_") if not arr[i].nil?
        #     end
    
        # end
    
        # ["1 пара И 170_СПП* *Артемов С.В._202Л", "2 пара ИД 162_ОИБ* *Артемов С.В._108Л", "3 пара ИД 162_СПП* *Артемов С.В._108Л"]
        
        for arr in new_s
            
            i = 0
            while i < arr.size - 1
                if arr[i][0].to_i > arr[i+1][0].to_i
                    arr[i],arr[i+1] = arr[i+1],arr[i]
                    i = 0
                    redo
                end
            i+=1
            end
    
        end
    
        return new_s
    end



           
       erb :search_result
    end

    def date?(date1,date2,group,predmet)


        current_time = Time.now.strftime("%y.%m.%d") # y.m.d
        year = '.2019'
    
        if (Date.parse(date1+year) <= Date.parse(current_time)) &&
            (Date.parse(current_time) <= Date.parse(date2+year))
            return "#{group} #{predmet}"
        else
            return false   
        end
    
    
    end

    def summa
     2 + 3
    end


    def time_practik?(str)
    
        days_practik = {

            "П 172" => ["2.09","14.09"],
            "П 173" => ["16.09","28.10"],
            "П 174" => ["30.09","12.10"],
            "П 162" => ["23.09","12.10"],
            "П 163" => ["14.10","2.11"],
            "П 164" => ["4.11","23.11"],
            "И 171" => ["30.09","12.10"],
        }

        year = '.2019'
        current_time = Time.now.strftime("%y.%m.%d") # y.m.d
    

        # если у группы вообще есть практика
        if days_practik.key?(str)

            a = days_practik[str][0]
            b = days_practik[str][1]
        
            # p Date.parse(a + year)
            # p Date.parse(current_time)
            # p Date.parse(b + year)
    
            if (Date.parse(a + year) <= Date.parse(current_time)) &&
                (Date.parse(current_time) <= Date.parse(b + year))
                return true    
            end
        end
    
        return false
    
    end
    


class String
    def practik?

        
            for i in GROUPS.keys
                if self.include?(i) and time_practik?(i)
                    # p self.include?(i)
                    # p i
                    # p time_practik?(i)
                    # p "__"
                    return true
                end
            end


        return false
    end
end


class NilClass
    def practik?
        return false
    end
end

class Array
    def practik?
        return false
    end
end


helpers do

    def date?(date1,date2,group,predmet,str)

        if str == "Артемов"

            current_time = Time.now.strftime("%y.%m.%d") # y.m.d
            year = '.2019'
        
            if (Date.parse(date1+year) <= Date.parse(current_time)) &&
                (Date.parse(current_time) <= Date.parse(date2+year))
                return "#{group} #{predmet}"
            else
                return false   
            end

        end
    
    
    end


  end

