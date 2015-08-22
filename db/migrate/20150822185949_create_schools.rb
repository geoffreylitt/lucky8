class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :hours

      t.text   :how_to_apply
      t.text   :about

      t.integer :four_yr_graduated
      t.integer :four_yr_dropped_out
      t.integer :four_yr_still_in_school
      t.integer :four_yr_ged

      t.integer :post_grad_four_yr_college
      t.integer :post_grad_two_yr_college
      t.integer :post_grad_unknown

      t.integer :school_size_9_grade
      t.integer :school_size_10_grade
      t.integer :school_size_11_grade
      t.integer :school_size_12_grade
      t.integer :school_size_unknown
      
      t.integer :other_key_indic_attendance_rate
      t.integer :other_key_indic_sp_education
      t.integer :other_key_indic_stud_teach_ratio

      t.integer :school_population_hispanic
      t.integer :school_population_african_american
      t.integer :school_population_white
      t.integer :school_population_asian
      t.integer :school_population_multi_race_non_hispanic

      t.integer :mcas_ela_advanced
      t.integer :mcas_ela_proficient
      t.integer :mcas_ela_needs_improv
      t.integer :mcas_ela_fail

      t.integer :mcas_math_advanced
      t.integer :mcas_math_proficient
      t.integer :mcas_math_needs_improv
      t.integer :mcas_math_fail

      t.timestamps
    end
  end
end
