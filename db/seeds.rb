# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(email: "librarian@test.com", password: "123456", name: "The Librarian", role: "LIBRARIAN")

100.times do
  Book.create(
    title: Faker::Book.title,
    author: Faker::Book.author,
    published_year: Faker::Number.between(from: 1900, to: 2020),
    serial_number: Faker::Number.number(digits: 10),
    genre: Faker::Book.genre
  )
end
