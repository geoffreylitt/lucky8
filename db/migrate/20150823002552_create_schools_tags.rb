class CreateSchoolsTags < ActiveRecord::Migration
  def change
    create_join_table :schools, :tags do |t|
      t.index [:school_id, :tag_id]
      t.index [:tag_id, :school_id]
    end
  end
end
