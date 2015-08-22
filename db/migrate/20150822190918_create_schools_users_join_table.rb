class CreateSchoolsUsersJoinTable < ActiveRecord::Migration
  def change
    create_join_table :schools, :users do |t|
      t.index [:school_id, :user_id]
      t.index [:user_id, :school_id]
    end
  end
end
