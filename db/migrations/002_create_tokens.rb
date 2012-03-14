# Create initial schema for the table of registration tokens.
#
# +---------------------+-------------------------------------------------+
# | Field               | Description                                     |
# +---------------------+-------------------------------------------------+
# | id                  | Identification number of token.                 |
# | requester_authname  | IRC authname, which has requested registration. |
# | kag_name            | Existing player's nickname, to be registered.   |
# | premium             | Existing player's account (true, if premium).   |
# | token               | Unique token value.                             |
# | created_at          | Date, when token was created at.                |
# | expires_at          | Token expiration date.                          |
# +---------------------+-------------------------------------------------+
#
Sequel.migration do
  change do
    create_table :tokens do
      primary_key :id
      String      :requester_authname, :unique => true, :size => 15, :null => false
      String      :kag_name,           :unique => true, :size => 20, :null => false
      FalseClass  :premium,            :default => false
      String      :token,              :unique => true, :size => 8,  :null => false
      DateTime    :created_at,         :null => false
      DateTime    :expires_at,         :null => false
    end
  end
end
