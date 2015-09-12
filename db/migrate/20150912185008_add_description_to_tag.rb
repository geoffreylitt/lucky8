class AddDescriptionToTag < ActiveRecord::Migration
  def change
    add_column :tags, :description, :text
  end
end
