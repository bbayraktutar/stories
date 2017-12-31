class AddFeaturedToTags < ActiveRecord::Migration[5.1]
  def change
    add_column :tags, :featured, :boolean, default: false
  end
end
