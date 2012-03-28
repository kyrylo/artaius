Sequel.migration do
  change do
    create_table :strangers do
      primary_key :id
      String      :irc_authname, :size => 15, :null => false, :unique => true
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
