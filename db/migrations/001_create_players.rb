# Create initial schema for the table of KAG players.
#
# Note, that while KAG's maximum length of nicknames is equal to 20,
# QuakeNet allows only 15 letters (NICKLEN field in the ISUPPORT message).
Sequel.migration do
  change do
    create_table :players do
      primary_key :id
      String      :irc_authname,  :unique  => true, :size => 15, :null => false
      String      :irc_alias,     :unique  => true, :size => 15
      String      :kag_name,      :unique  => true, :size => 20, :null => false
      FalseClass  :premium,       :default => false
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
