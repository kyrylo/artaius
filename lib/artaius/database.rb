module Artaius
  ###
  # Connects to the Artaius' database.
  Database = Sequel.sqlite(File.join(ENV['DB_PATH'], 'artaius.db'))
  class << Database

    # Runs a migration from 'db/migrations' directory.
    def migrate(to=nil, from=nil)
      migrations_dir = File.join(ENV['DB_PATH'], 'migrations')
      Sequel::Migrator.apply(self, migrations_dir, to, from)
    end

    # Rollbacks a migration to the previous version.
    def rollback
      version = self[:schema_info].first[:version]
      migrate(version.pred)
    end

  end
end
