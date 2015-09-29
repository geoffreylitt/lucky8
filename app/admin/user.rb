ActiveAdmin.register User do
  actions :index, :show

  index do
    id_column
    column :name
    column :email
    actions
  end

  show do
    attributes_table do
      row :name
      row :email
      row :sign_in_count
      row :current_sign_in_at
      row :last_sign_in_at
      row :created_at
    end

    panel "Saved Schools" do
      table_for user.schools do |t|
        t.column("ID"){ |school| school.id }
        t.column("Name"){ |school| link_to school.name, admin_school_path(school) }
      end
    end
  end
end
