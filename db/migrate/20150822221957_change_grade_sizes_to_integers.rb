class ChangeGradeSizesToIntegers < ActiveRecord::Migration
  def change
    change_column :schools, :school_size_9_grade, :integer
    change_column :schools, :school_size_10_grade, :integer
    change_column :schools, :school_size_11_grade, :integer
    change_column :schools, :school_size_12_grade, :integer
  end
end
