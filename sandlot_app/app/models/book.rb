class Book < ActiveRecord::Base
  belongs_to :publisher
  belongs_to :author
  has_many :book_reviews
  has_many :book_formats
  has_many :book_format_types, through: :book_formats

  validates :title, :author_id, :publisher_id, presence: true

  def author_name
    "#{author.last_name}, #{author.first_name}"
  end

  def average_rating
    book_reviews.average("rating")
  end
end
