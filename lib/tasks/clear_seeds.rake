namespace :db do
    desc "clear seeds"
    task clear_seeds: :environment do
      puts "clearing courses"
      Course.delete_all
    end
end
