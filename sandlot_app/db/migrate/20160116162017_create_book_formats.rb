class CreateBookFormats < ActiveRecord::Migration
  def change
    create_table :book_formats do |t|
      t.references :book, index: true
      t.references :book_format_type, index: true

      t.timestamps null: false
    end
    add_foreign_key :book_formats, :books
    add_foreign_key :book_formats, :book_format_types
  end
end
