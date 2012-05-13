# Create initial schema for the table of news (tiles) from KAG development blog.
#
# +--------------+----------------------------+
# | Field        | Description                |
# +--------------+----------------------------+
# | id           | News id number.            |
# | title        | News title.                |
# | date         | Date, when news were added.|
# | author       | Author of the news.        |
# | link         | Link to post on the web.   |
# +--------------+----------------------------+
#
Sequel.migration do
  change do
    create_table :news do
      primary_key :id
      String      :title,     :size => 255,  :null => false
      DateTime    :date
      String      :author,    :size => 32,   :null => false
      String      :link,                     :null => false
      DateTime    :created_at
      DateTime    :updated_at
    end
  end
end
