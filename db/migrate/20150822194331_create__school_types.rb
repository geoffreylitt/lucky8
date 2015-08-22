class CreateSchoolTypes < ActiveRecord::Migration
  def change
    create_table :school_types, id: false do |t|
      t.belongs_to :school, index: true
      t.belongs_to :type, index: true
    end
  end
end
