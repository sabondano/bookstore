class CreateBookFormatTypes < ActiveRecord::Migration
  def change
    create_table :book_format_types do |t|
      t.string :name
      t.boolean :physical

      t.timestamps null: false
    end
  end
end
