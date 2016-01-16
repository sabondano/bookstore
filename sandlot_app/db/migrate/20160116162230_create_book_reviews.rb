class CreateBookReviews < ActiveRecord::Migration
  def change
    create_table :book_reviews do |t|
      t.references :book, index: true
      t.integer :rating

      t.timestamps null: false
    end
    add_foreign_key :book_reviews, :books
  end
end
