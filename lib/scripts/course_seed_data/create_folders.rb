require "fileutils"

dirr = File.join(Dir.pwd, "db", "course_seeds")
years = [ "2020", "2021", "2022", "2023", "2024", "2025" ]
terms = [ "Fall", "Spring", "Summer" ]
depts = [ "cmpt", "math", "macm" ]

years.each do |year|
    terms.each do |term|
        depts.each do |dept|
            folder_path = File.join(dirr, year, term, dept)
            FileUtils.mkdir_p(folder_path)
            puts "created dir #{folder_path}"
        end
    end
end
