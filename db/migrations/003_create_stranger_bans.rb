# Create initial schema for the table of bans of *unregistered* users (strangers).
#
# +----------------------------+-----------------------------------------------+
# | Field                      | Description                                   |
# +----------------------------+-----------------------------------------------+
# | id                         | Identification number of ban of a stranger.   |
# | stranger_id (FK)           | Identification number of a stranger           |
# | ban_status                 | In order to avoid duplications of stranger    |
# |                            | IDs, we make use of this field, so every      |
# |                            | banned authname will appear in the table      |
# |                            | only once. The default value of this field    |
# |                            | is _true_.                                    |
# +----------------------------+-----------------------------------------------+
#
Sequel.migration do
  change do
    create_table :stranger_ban do
      primary_key :id
      foreign_key :stranger_id, :strangers, :null => false, :unique => true
      TrueClass   :ban_status,  :default => true, :null => false
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
