class AddOrgIdToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :org_id, :string
  end
end
