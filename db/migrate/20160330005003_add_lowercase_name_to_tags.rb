class AddLowercaseNameToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :lowercase_name, :string
  end
end
