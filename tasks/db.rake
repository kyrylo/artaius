namespace :db do
  desc 'Run migrations'
  task :migrate => :environment do
    to   = ENV['TO'].to_i
    from = ENV['FROM'].to_i
    Artaius::Database.migrate(to, from)
  end

  desc 'Roll the database back a version'
  task :rollback => :environment do
    Artaius::Database.rollback
  end
end
