class ModifySchoolFields < ActiveRecord::Migration
  def change
    remove_column :schools, :other_key_indic_sp_education, :float
    remove_column :schools, :other_key_indic_stud_teach_ratio, :float

    rename_column :schools, :other_key_indic_attendance_rate, :attendance_rate

    add_column :schools, :ell_percentage, :float
  end
end
