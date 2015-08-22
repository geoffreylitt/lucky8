class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :hours

      t.text   :how_to_apply
      t.text   :about

      t.float :four_yr_graduated
      t.float :four_yr_dropped_out
      t.float :four_yr_still_in_school
      t.float :four_yr_ged

      t.float :post_grad_four_yr_college
      t.float :post_grad_two_yr_college
      t.float :post_grad_unknown

      t.float :school_size_9_grade
      t.float :school_size_10_grade
      t.float :school_size_11_grade
      t.float :school_size_12_grade
      t.float :school_size_unknown
      
      t.float :other_key_indic_attendance_rate
      t.float :other_key_indic_sp_education
      t.float :other_key_indic_stud_teach_ratio

      t.float :school_population_hispanic
      t.float :school_population_african_american
      t.float :school_population_white
      t.float :school_population_asian
      t.float :school_population_multi_race_non_hispanic

      t.float :mcas_ela_advanced
      t.float :mcas_ela_proficient
      t.float :mcas_ela_needs_improv
      t.float :mcas_ela_fail

      t.float :mcas_math_advanced
      t.float :mcas_math_proficient
      t.float :mcas_math_needs_improv
      t.float :mcas_math_fail

      t.string :image_url

      t.timestamps
    end
  end
end
