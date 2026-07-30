require "net/http"
require "json"

puts "Deleting old data..."

OrderItem.destroy_all
CartItem.destroy_all
Order.destroy_all
User.destroy_all
Product.destroy_all
Category.destroy_all
Province.destroy_all

fiction = Category.create!(
  name: "Fiction",
  description: "Fiction Books"
)

education = Category.create!(
  name: "Education",
  description: "Educational Books"
)

children = Category.create!(
  name: "Children",
  description: "Children Books"
)

programming = Category.create!(
  name: "Programming",
  description: "Programming Books"
)

categories = [ fiction, education, children, programming ]

subjects = [
  "fiction",
  "science",
  "children",
  "programming"
]

subjects.each_with_index do |subject, index|
  url = URI("https://openlibrary.org/subjects/#{subject}.json?limit=25")

  response = Net::HTTP.get(url)

  books = JSON.parse(response)

  books["works"].each do |book|
    Product.create!(
      title: book["title"],
      author: book["authors"]&.first&.dig("name") || "Unknown",
      isbn: rand(1000000000000..9999999999999).to_s,
      description: "Imported from Open Library",
      price: rand(10..60),
      stock_quantity: rand(5..40),
      image_url: book["cover_id"] ? "https://covers.openlibrary.org/b/id/#{book['cover_id']}-L.jpg" : "",
      category: categories[index]
    )
  end
end

puts "Done!"
puts "#{Category.count} categories created"
puts "#{Product.count} products created"


Province.create!(name: "Alberta", gst: 0.05, pst: 0.00, hst: 0.00)
Province.create!(name: "British Columbia", gst: 0.05, pst: 0.07, hst: 0.00)
Province.create!(name: "Manitoba", gst: 0.05, pst: 0.07, hst: 0.00)
Province.create!(name: "New Brunswick", gst: 0.00, pst: 0.00, hst: 0.15)
Province.create!(name: "Newfoundland and Labrador", gst: 0.00, pst: 0.00, hst: 0.15)
Province.create!(name: "Nova Scotia", gst: 0.00, pst: 0.00, hst: 0.15)
Province.create!(name: "Ontario", gst: 0.00, pst: 0.00, hst: 0.13)
Province.create!(name: "Prince Edward Island", gst: 0.00, pst: 0.00, hst: 0.15)
Province.create!(name: "Quebec", gst: 0.05, pst: 0.09975, hst: 0.00)
Province.create!(name: "Saskatchewan", gst: 0.05, pst: 0.06, hst: 0.00)
Province.create!(name: "Northwest Territories", gst: 0.05, pst: 0.00, hst: 0.00)
Province.create!(name: "Nunavut", gst: 0.05, pst: 0.00, hst: 0.00)
Province.create!(name: "Yukon", gst: 0.05, pst: 0.00, hst: 0.00)
