# Create initial schema for the table of registration tokens.
#
# +------------------------+-------------------------------------------------+
# | Field                  | Description                                     |
# +------------------------+-------------------------------------------------+
# | id                     | Identification number of token.                 |
# | stranger_id            | ID of person, that requested a token.           |
# | provided_kag_name      | Existing player's nickname, to be registered.   |
# | token                  | Unique token value.                             |
# | created_at             | Date, when token was created at.                |
# | expires_at             | Token expiration date.                          |
# +------------------------+-------------------------------------------------+
#
Sequel.migration do
  change do
    create_table :tokens do
      primary_key :id
      foreign_key :stranger_id, :strangers
      String      :provided_kag_name, :size => 20, :null => false
      String      :token,             :size => 8,  :null => false, :unique => true
      DateTime    :created_at,                     :null => false
      DateTime    :expires_at,                     :null => false
    end
  end
end
