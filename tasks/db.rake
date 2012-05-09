namespace :db do

  desc 'Run migrations'
  task :migrate => :environment do
    to   = ENV['TO'].to_i
    from = ENV['FROM'].to_i
    Artaius::Database.migrate(to, from)
  end

  desc 'Rollback database to the previous version'
  task :rollback => :environment do
    Artaius::Database.rollback
  end

end
