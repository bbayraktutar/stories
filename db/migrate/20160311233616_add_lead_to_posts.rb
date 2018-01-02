class AddLeadToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :lead, :text
  end
end
