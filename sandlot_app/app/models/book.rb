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

  def self.search(query, options = {})
    options = { title_only: false,
                book_format_type_id: nil }.merge(options)

    if options[:title_only]
      search_results = search_by_book_title(query)
    end

    unless options[:title_only]
      search_results = search_by_author_last_name(query) |
        search_by_publisher_name(query) |
        search_by_book_title(query)
    end

    if book_format_type_id = options[:book_format_type_id]
      search_results.select! do |book|
        book.book_format_types.map(&:id).include?(book_format_type_id)
      end
    end

    search_results.sort_by(&:average_rating).reverse
  end

  private

  def self.search_by_author_last_name(last_name)
    Author.where("lower(last_name) = ?", last_name.downcase).flat_map(&:books)
  end

  def self.search_by_publisher_name(name)
    Publisher.where("lower(name) = ?", name.downcase).flat_map(&:books)
  end

  def self.search_by_book_title(title)
    books = Book.where("lower(title) like ?", "%#{title.downcase}%")
  end
end
