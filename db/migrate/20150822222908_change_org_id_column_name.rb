class ChangeOrgIdColumnName < ActiveRecord::Migration
  def change
    rename_column :schools, :org_id, :org_id_number
  end
end
