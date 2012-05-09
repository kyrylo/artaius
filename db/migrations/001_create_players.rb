# Create initial schema for the table of registered players.
#
# Note, that while KAG's maximum length of nicknames is equal to 20,
# QuakeNet allows only 15 letters (NICKLEN field in the ISUPPORT message).
#
# +--------------+--------------------------------------+
# | Field        | Description                          |
# +--------------+--------------------------------------+
# | id           | Player id number.                    |
# | irc_authname | IRC authname of player.              |
# | kag_nick     | King Arthur's Gold in-game nickname. |
# | role         | Role of the player [1]               |
# | premium      | Account type (true if premium).      |
# +--------------+--------------------------------------+
#
# [1] Roles:
#   0: Normal player account
#   1: KAG dev/team member
#   2: KAG Guard.
#   4: KAG team member ("admin" level, more or less the same as type 1)
#   5: Possibly a tester, but most testers are not currently flagged
#
Sequel.migration do
  change do
    create_table :players do
      primary_key :id
      String      :irc_authname, :unique  => true, :size => 15, :null => false
      String      :kag_nick,     :unique  => true, :size => 20, :null => false
      Fixnum      :role,         :null    => false
      FalseClass  :premium,      :null    => false
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
