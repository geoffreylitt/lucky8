class FixSchoolsTypesTableName < ActiveRecord::Migration
  def change
    rename_table :school_types, :schools_types
  end
end
