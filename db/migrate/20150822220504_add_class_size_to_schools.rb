class AddClassSizeToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :avg_class_size, :float
  end
end
