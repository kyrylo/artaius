module Artaius
  # Internal: Connect Artaius to the database via Sequel interface.
  Database = Sequel.sqlite(File.join(File.expand_path('db'), 'artaius.db'))

  class << Database

    # Internal: Migrate database from older version to the new one or vice
    # versa. Without given arguments, migrate database to the latest version
    # available.
    #
    # to   - The Integer, describes version, to version till which migrations
    #        should be applied (default: nil).
    # from - The Integer, describes version, from which migration should start
    #        its work (default: nil).
    #
    # Returns nothing.
    def migrate(to = nil, from = nil)
      migrations = File.join(File.expand_path('db'), 'migrations')
      if to == 0 && from == 0
        Sequel::Migrator.apply(self, migrations)
      else
        Sequel::Migrator.apply(self, migrations, to, from)
      end
    end

    # Internal: Rollback current version of database to the previous one. This
    # method returns database exactly one step back.
    #
    # Returns nothing
    def rollback
      current_version = self[:schema_info].first[:version]
      migrate(current_version.pred)
    end

  end
end
