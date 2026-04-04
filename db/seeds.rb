# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# --- Brands ---

puts "Seeding brands..."

brands = {}

[
  { name: "Ambrosoli", description: "Chilean confectionery company founded in 1948, known for caramels and hard candies.", country_of_origin: "Chile" },
  { name: "Costa", description: "Major Chilean chocolate and candy manufacturer, founded in 1916.", country_of_origin: "Chile" },
  { name: "Dos en Uno", description: "Chilean candy brand known for gummies and fruit-flavored sweets.", country_of_origin: "Chile" },
  { name: "McKay", description: "Chilean cookie and wafer brand, part of Nestlé Chile.", country_of_origin: "Chile" },
  { name: "Arcor Chile", description: "Chilean subsidiary of the Argentine confectionery giant Arcor.", country_of_origin: "Argentina" }
].each do |attrs|
  brands[attrs[:name]] = Brand.find_or_create_by!(name: attrs[:name]) do |b|
    b.description = attrs[:description]
    b.country_of_origin = attrs[:country_of_origin]
  end
end

puts "  #{Brand.count} brands seeded."

# --- Categories ---

puts "Seeding categories..."

categories = {}

[
  { name: "Chocolate", description: "Chocolate bars and chocolate-covered treats." },
  { name: "Caramelo", description: "Hard and soft caramels." },
  { name: "Galleta", description: "Cookies and wafer-based treats." },
  { name: "Gomita", description: "Gummy candies and jelly sweets." },
  { name: "Chupete", description: "Lollipops and sucking candies." }
].each do |attrs|
  categories[attrs[:name]] = Category.find_or_create_by!(name: attrs[:name]) do |c|
    c.description = attrs[:description]
  end
end

puts "  #{Category.count} categories seeded."

# --- Candies ---

puts "Seeding candies..."

[
  # Costa — Chocolate
  {
    name: "Super Ocho",
    brand: "Costa", category: "Chocolate",
    description: "Iconic Chilean wafer bar covered in chocolate, filled with caramel. A national classic since 1956.",
    year_introduced: 1956, discontinued: false
  },
  {
    name: "Cocoa",
    brand: "Costa", category: "Chocolate",
    description: "Classic Chilean chocolate bar with a crispy wafer center.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Triángulo",
    brand: "Costa", category: "Chocolate",
    description: "Triangle-shaped chocolate with a crunchy filling.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Chokita",
    brand: "Costa", category: "Chocolate",
    description: "Small chocolate-covered candy. Originally sold as Negritas, renamed Chokita.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Sapito",
    brand: "Costa", category: "Chocolate",
    description: "Small frog-shaped chocolate candy, a favorite among children.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Bon o Bon",
    brand: "Costa", category: "Chocolate",
    description: "Chocolate-covered ball filled with peanut cream and wafer crumble.",
    year_introduced: nil, discontinued: false
  },

  # Ambrosoli — Caramelo
  {
    name: "Caluga Media Hora",
    brand: "Ambrosoli", category: "Caramelo",
    description: "Traditional Chilean soft caramel, said to take half an hour to finish.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Mentita",
    brand: "Ambrosoli", category: "Caramelo",
    description: "Classic mint-flavored hard candy with a distinctive green wrapper.",
    year_introduced: 1950, discontinued: false
  },
  {
    name: "Calugas Surtidas",
    brand: "Ambrosoli", category: "Caramelo",
    description: "Assorted soft caramels in multiple flavors.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Frutilla",
    brand: "Ambrosoli", category: "Caramelo",
    description: "Strawberry-flavored hard candy, one of Ambrosoli's most recognized flavors.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Butter Toffees Ambrosoli",
    brand: "Ambrosoli", category: "Caramelo",
    description: "Creamy butter toffee caramels individually wrapped.",
    year_introduced: nil, discontinued: false
  },

  # Ambrosoli — Chupete
  {
    name: "Chupete Ambrosoli",
    brand: "Ambrosoli", category: "Chupete",
    description: "Classic lollipop in assorted fruit flavors, an Ambrosoli staple.",
    year_introduced: nil, discontinued: false
  },

  # Dos en Uno — Gomita
  {
    name: "Mellizos",
    brand: "Dos en Uno", category: "Gomita",
    description: "Twin-shaped gummy candies in fruit flavors, a Chilean childhood classic.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Fruna",
    brand: "Dos en Uno", category: "Gomita",
    description: "Soft fruit-flavored candy, one of the most iconic Chilean sweets.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Nik",
    brand: "Dos en Uno", category: "Gomita",
    description: "Small round gummies with a powdery sour coating.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Ácida",
    brand: "Dos en Uno", category: "Gomita",
    description: "Intensely sour gummy belts in assorted fruit flavors.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Gomitas Ositos",
    brand: "Dos en Uno", category: "Gomita",
    description: "Classic bear-shaped gummies in assorted fruit flavors.",
    year_introduced: nil, discontinued: false
  },

  # Dos en Uno — Chupete
  {
    name: "Blow Pop",
    brand: "Dos en Uno", category: "Chupete",
    description: "Lollipop with a bubblegum center in various fruit flavors.",
    year_introduced: nil, discontinued: false
  },

  # McKay — Galleta
  {
    name: "Kuky",
    brand: "McKay", category: "Galleta",
    description: "Chocolate-covered cream-filled wafer bar, a McKay icon.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Tritón",
    brand: "McKay", category: "Galleta",
    description: "Sandwich cookie with vanilla cream filling, Chile's answer to Oreo.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Chocman",
    brand: "McKay", category: "Galleta",
    description: "Chocolate-flavored sandwich cookie with chocolate cream filling.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Óptimus",
    brand: "McKay", category: "Galleta",
    description: "Classic rectangular tea biscuit, widely used in Chilean desserts.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Poker",
    brand: "McKay", category: "Galleta",
    description: "Thin, crispy rectangular crackers, a staple in Chilean households.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Morocha",
    brand: "McKay", category: "Galleta",
    description: "Dark chocolate wafer filled with vanilla cream.",
    year_introduced: nil, discontinued: false
  },

  # Arcor Chile — Chocolate
  {
    name: "Bon o Bon Arcor",
    brand: "Arcor Chile", category: "Chocolate",
    description: "Argentine-origin chocolate ball with peanut cream filling, popular across Chile.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Cofler",
    brand: "Arcor Chile", category: "Chocolate",
    description: "Milk chocolate bar with rice crisps, made by Arcor.",
    year_introduced: nil, discontinued: false
  },

  # Arcor Chile — Caramelo
  {
    name: "Rocklets",
    brand: "Arcor Chile", category: "Chocolate",
    description: "Colorful candy-coated chocolate buttons, Chile's equivalent of M&Ms.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Butter Toffees Arcor",
    brand: "Arcor Chile", category: "Caramelo",
    description: "Smooth butter-flavored toffee caramels in gold wrappers.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Arcor Masticables",
    brand: "Arcor Chile", category: "Caramelo",
    description: "Soft, chewy fruit-flavored caramels in assorted flavors.",
    year_introduced: nil, discontinued: false
  }
].each do |attrs|
  Candy.find_or_create_by!(name: attrs[:name]) do |c|
    c.brand = brands[attrs[:brand]]
    c.category = categories[attrs[:category]]
    c.description = attrs[:description]
    c.year_introduced = attrs[:year_introduced]
    c.discontinued = attrs[:discontinued]
  end
end

puts "  #{Candy.count} candies seeded."
puts "Done! Seeded #{Brand.count} brands, #{Category.count} categories, #{Candy.count} candies."
