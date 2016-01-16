class Book < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :author
  has_many :book_reviews
  has_many :book_formats
  has_many :book_format_types, through: :book_formats
end
