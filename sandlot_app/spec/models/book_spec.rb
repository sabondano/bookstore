require 'rails_helper'

describe Book do
  before do
    @publisher = Publisher.create!(name: 'Pearson')
    @author = Author.create!(first_name: 'William', last_name: 'Shakespeare')

    BookFormatType.create!(name: 'Hardcover', physical: true)
    BookFormatType.create!(name: 'Softcover', physical: true)
    BookFormatType.create!(name: 'Kindle', physical: false)
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
end
