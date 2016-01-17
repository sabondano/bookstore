require 'rails_helper'

describe Book do
  before do
    @publisher = Publisher.create!(name: 'Pearson')
    @publisher_2 = Publisher.create!(name: 'Simon & Schuster Inc')
    @author = Author.create!(first_name: 'William', last_name: 'Shakespeare')
    @author_2 = Author.create!(first_name: 'Stephen', last_name: 'King')

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
    it "returns a collection of the BookFormatTypes the book is available in" do
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
    it "returns the name of the author of this book in
        'lastname, firstname' format" do
      book = Book.create(
        title: "Romeo and Juliet",
        publisher_id: @publisher.id,
        author_id: @author.id
      )

      expect(book.author_name).to eq("Shakespeare, William")
    end
  end

  describe "#average_rating" do
    it "returns the average (mean) of all the book reviews for this book
        (rounded to one decimal place)" do
      book = Book.create(
        title: "Romeo and Juliet",
        publisher_id: @publisher.id,
        author_id: @author.id
      )

      book.book_reviews.create(rating: 3)
      book.book_reviews.create(rating: 5)
      book.book_reviews.create(rating: 4)

      expect(book.average_rating).to eq(4.0)
    end
  end

  describe "#search(query, options)" do
    context "if the last name of the author matches the query string exactly" do
      it "returns a collection of books that match the query string" do
        book_1 = Book.create(
          title: "Romeo and Juliet",
          publisher_id: @publisher.id,
          author_id: @author.id
        )

        book_2 = Book.create(
          title: "Something Else",
          publisher_id: @publisher.id,
          author_id: @author_2.id
        )

        search_results = Book.search("king")

        expect(search_results.count).to eq(1)
        expect(search_results.first.title).to eq("Something Else")
      end
    end

    context "if the name of the publisher matches the query string exactly" do
      it "returns a collection of books that match the query string" do
        book_1 = Book.create(
          title: "Romeo and Juliet",
          publisher_id: @publisher.id,
          author_id: @author.id
        )

        book_2 = Book.create(
          title: "Something Else",
          publisher_id: @publisher.id,
          author_id: @author_2.id
        )

        book_3 = Book.create(
          title: "Terakeeting",
          publisher_id: @publisher_2.id,
          author_id: @author.id
        )

        search_results = Book.search("pearson")

        expect(search_results.count).to eq(2)
        expect(search_results.first.title).to eq("Something Else")
        expect(search_results.last.title).to eq("Romeo and Juliet")
      end
    end

    context "if any portion of the book's title matches the query string" do
      it "returns a collection of books that match the query string" do
        book_1 = Book.create(
          title: "Romeo and Juliet",
          publisher_id: @publisher.id,
          author_id: @author.id
        )

        book_2 = Book.create(
          title: "Something Else",
          publisher_id: @publisher.id,
          author_id: @author_2.id
        )

        book_3 = Book.create(
          title: "Terakeeting",
          publisher_id: @publisher_2.id,
          author_id: @author.id
        )

        search_results = Book.search("juliet")

        expect(search_results.count).to eq(1)
        expect(search_results.first.title).to eq("Romeo and Juliet")
      end 
    end

    context "the results should be ordered by average rating (highest first)" do
      it "returns a collection of books that match the query string" do
        book_1 = Book.create(
          title: "Romeo and Juliet",
          publisher_id: @publisher.id,
          author_id: @author.id
        )

        book_2 = Book.create(
          title: "Something Else",
          publisher_id: @publisher.id,
          author_id: @author_2.id
        )

        book_3 = Book.create(
          title: "Terakeeting",
          publisher_id: @publisher.id,
          author_id: @author.id
        )

        book_1.book_reviews.create(rating: 2)
        book_2.book_reviews.create(rating: 4)
        book_3.book_reviews.create(rating: 3)

        search_results = Book.search("pearson")

        expect(search_results.first.title).to eq("Something Else")
        expect(search_results.last.title).to eq("Romeo and Juliet")
      end
    end

    context "if :title_only option is true" do
      it "returns a collection of books searching only by book title" do
        book_1 = Book.create(
          title: "The Pearson Book",
          publisher_id: @publisher.id,
          author_id: @author.id
        )

        book_2 = Book.create(
          title: "Romeo and Juliet",
          publisher_id: @publisher.id,
          author_id: @author.id
        )

        search_results = Book.search("pearson", title_only: true)

        expect(search_results.count).to eq(1)
        expect(search_results.first.title).to eq("The Pearson Book")
      end
    end

    context "if :book_format_type_id is given" do
      it "returns a collection of books that are available in matching format" do
        book_1 = Book.create(
          title: "Romeo and Juliet",
          publisher_id: @publisher.id,
          author_id: @author.id
        )

        BookFormat.create(
          book_id: book_1.id,
          book_format_type_id: @hardcover_format.id
        )

        book_2 = Book.create(
          title: "The Pearson Book",
          publisher_id: @publisher.id,
          author_id: @author.id
        )

        search_results = Book.search("pearson", book_format_type_id: @hardcover_format.id)

        expect(search_results.count).to eq(1)
        expect(search_results.first.title).to eq("Romeo and Juliet")
      end
    end
  end
end
