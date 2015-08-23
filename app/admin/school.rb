ActiveAdmin.register School do
  index do
    id_column
    column :name
    actions
  end

  permit_params tag_ids: []

  form do |f|
    f.inputs
    f.input :tags, :as => :check_boxes, :input_html => {:multiple => true}
    f.actions
  end

  show do
    attributes_table(*School.column_names)
    attributes_table do
      row :tags do
        school.tags.map(&:name).join(", ")
      end
    end
  end
end
