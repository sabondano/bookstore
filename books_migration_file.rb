class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.references :publisher, index: true
      t.references :author, index: true

      t.timestamps null: false
    end
    add_foreign_key :books, :publishers
    add_foreign_key :books, :authors
  end
end
