ActiveAdmin.register School do
  index do
    id_column
    column :name
    actions
  end

  form do |f|
    f.inputs "Basic info" do
      f.input :name
      f.input :hours
      f.input :about, as: :html_editor
      f.input :how_to_apply, as: :html_editor
      f.input :image_url, hint: "A URL for an image to display on this school's information page"
      f.input :org_id_number, label: "Org ID Number", hint: "The ID number for this school on the Mass DESE school profiles site (to allow for automatic data scraping)"
      f.input :tags, as: :check_boxes, input_html: {multiple: true}
    end

    f.inputs "Detailed stats (Automatically scraped)" do
      (School.column_names.map(&:to_sym) - [:id, :name, :hours, :about, :how_to_apply, :image_url, :org_id_number, :tags, :latitude, :longitude, :created_at, :updated_at]).each do |column|
        f.input column
      end
    end

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
