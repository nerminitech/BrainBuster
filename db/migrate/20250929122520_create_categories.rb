class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :featured, null: false, default: false

      t.timestamps
    end

    add_index :categories, :name, unique: true
  end
end
