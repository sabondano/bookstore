require 'rails_helper'

describe Book do
  before do
    @publisher = Publisher.create!(name: 'Pearson')
    @author = Author.create!(first_name: 'William', last_name: 'Shakespeare')

    @hardcover_format = BookFormatType.create!(name: 'Hardcover', physical: true)
    @softcover_format = BookFormatType.create!(name: 'Softcover', physical: true)
    @kindle_format = BookFormatType.create!(name: 'Kindle', physical: false)
  end

  it "is valid with valid attributes" do
    book = Book.new(
      title: "Romeo and Juliet",
      publisher_id: @publisher.id,
      author_id: @author.id
    )

    expect(book).to be_valid
  end

  it "is not valid without a title" do
    book = Book.new(
      title: nil,
      publisher_id: @publisher.id,
      author_id: @author.id
    )

    expect(book).to be_invalid
  end

  it "is not valid without an author_id" do
    book = Book.new(
      title: "Romeo and Juliet",
      publisher_id: @publisher.id,
      author_id: nil
    )

    expect(book).to be_invalid
  end

  it "is not valid without a publisher_id" do
    book = Book.new(
      title: "Romeo and Juliet",
      publisher_id: nil,
      author_id: @author.id
    )

    expect(book).to be_invalid
  end

  describe "#book_format_types" do
    it "returns a collection of the BookFormatTypes this book is available in" do
      book = Book.create(
        title: "Romeo and Juliet",
        publisher_id: @publisher.id,
        author_id: @author.id
      )

      BookFormat.create(
        book_id: book.id,
        book_format_type_id: @hardcover_format.id
      )

      BookFormat.create(
        book_id: book.id,
        book_format_type_id: @kindle_format.id
      )

      format_types = book.book_format_types

      expect(format_types.count).to eq(2)
      expect(format_types.first.name).to eq("Hardcover")
      expect(format_types.last.name).to eq("Kindle")
    end
  end

  describe "#author_name" do
    it "returns the name of the author of this book in 'lastname, firstname' format" do
      book = Book.create(
        title: "Romeo and Juliet",
        publisher_id: @publisher.id,
        author_id: @author.id
      )

      expect(book.author_name).to eq("Shakespeare, William")
    end
  end
end
