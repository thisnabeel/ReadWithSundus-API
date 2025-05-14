class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.integer :guardian_id
      t.date :birthday

      t.timestamps
    end
  end
end
