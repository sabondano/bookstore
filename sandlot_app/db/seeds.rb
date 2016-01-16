# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Publisher.create!(name: 'Simon & Schuster Inc')
Publisher.create!(name: 'Pearson')

Author.create!(first_name: 'Stephen', last_name: 'King')
Author.create!(first_name: 'William', last_name: 'Shakespeare')

BookFormatType.create!(name: 'Hardcover', physical: true)
BookFormatType.create!(name: 'Softcover', physical: true)
BookFormatType.create!(name: 'Kindle', physical: false)
