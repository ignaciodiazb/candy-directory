# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# --- Brands ---

puts "Seeding brands..."

brands = {}

[
  { name: "Ambrosoli", description: "Empresa chilena de confites fundada en 1948, conocida por sus caramelos y dulces duros.", country_of_origin: "Chile" },
  { name: "Costa", description: "Gran fabricante chileno de chocolates y dulces, fundada en 1907.", country_of_origin: "Chile" },
  { name: "Dos en Uno", description: "Marca chilena de dulces conocida por sus gomitas y confites frutales.", country_of_origin: "Chile" },
  { name: "McKay", description: "Marca chilena de galletas y obleas, parte de Nestlé Chile.", country_of_origin: "Chile" },
  { name: "Arcor Chile", description: "Filial chilena del gigante argentino de golosinas Arcor.", country_of_origin: "Argentina" }
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
  { name: "Chocolates", description: "Barras de chocolate y golosinas cubiertas de chocolate." },
  { name: "Caramelos", description: "Caramelos duros y blandos." },
  { name: "Galletas", description: "Galletas y obleas." },
  { name: "Gomitas", description: "Caramelos de goma y gomitas." },
  { name: "Chupetes", description: "Chupetes y caramelos para chupar." }
].each do |attrs|
  categories[attrs[:name]] = Category.find_or_create_by!(name: attrs[:name]) do |c|
    c.description = attrs[:description]
  end
end

puts "  #{Category.count} categories seeded."

# --- Candies ---

puts "Seeding candies..."

[
  # Costa — Chocolates
  {
    name: "Super Ocho",
    brand: "Costa", category: "Chocolates",
    description: "Icónica barra de oblea cubierta de chocolate con relleno de caramelo. Un clásico nacional desde 1956.",
    year_introduced: 1956, discontinued: false
  },
  {
    name: "Cocoa",
    brand: "Costa", category: "Chocolates",
    description: "Clásica barra de chocolate chilena con centro de oblea crocante.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Triángulo",
    brand: "Costa", category: "Chocolates",
    description: "Chocolate con forma de triángulo y relleno crocante.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Chokita",
    brand: "Costa", category: "Chocolates",
    description: "Pequeño dulce cubierto de chocolate. Se vendía originalmente como Negritas.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Sapito",
    brand: "Costa", category: "Chocolates",
    description: "Pequeño chocolate con forma de rana, favorito de los niños.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Bon o Bon",
    brand: "Costa", category: "Chocolates",
    description: "Bolita cubierta de chocolate con relleno de crema de maní y trocitos de oblea.",
    year_introduced: nil, discontinued: false
  },

  # Ambrosoli — Caramelos
  {
    name: "Caluga Media Hora",
    brand: "Ambrosoli", category: "Caramelos",
    description: "Tradicional caluga blanda chilena, conocida por durar media hora.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Mentita",
    brand: "Ambrosoli", category: "Caramelos",
    description: "Clásico caramelo duro sabor menta con su característico envoltorio verde.",
    year_introduced: 1950, discontinued: false
  },
  {
    name: "Calugas Surtidas",
    brand: "Ambrosoli", category: "Caramelos",
    description: "Calugas blandas surtidas en múltiples sabores.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Frutilla",
    brand: "Ambrosoli", category: "Caramelos",
    description: "Caramelo duro sabor frutilla, uno de los más reconocidos de Ambrosoli.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Butter Toffees Ambrosoli",
    brand: "Ambrosoli", category: "Caramelos",
    description: "Cremosos toffees de mantequilla envueltos individualmente.",
    year_introduced: nil, discontinued: false
  },

  # Ambrosoli — Chupetes
  {
    name: "Chupete Ambrosoli",
    brand: "Ambrosoli", category: "Chupetes",
    description: "Clásico chupete en variados sabores de fruta, un clásico de Ambrosoli.",
    year_introduced: nil, discontinued: false
  },

  # Dos en Uno — Gomitas
  {
    name: "Mellizos",
    brand: "Dos en Uno", category: "Gomitas",
    description: "Gomitas con forma de mellizos en sabores frutales, un clásico de la infancia chilena.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Fruna",
    brand: "Dos en Uno", category: "Gomitas",
    description: "Dulce blando de fruta, uno de los más icónicos de Chile.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Nik",
    brand: "Dos en Uno", category: "Gomitas",
    description: "Pequeñas gomitas redondas con cubierta ácida en polvo.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Ácida",
    brand: "Dos en Uno", category: "Gomitas",
    description: "Tiras de gomita intensamente ácidas en variados sabores frutales.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Gomitas Ositos",
    brand: "Dos en Uno", category: "Gomitas",
    description: "Clásicas gomitas con forma de oso en sabores frutales surtidos.",
    year_introduced: nil, discontinued: false
  },

  # Dos en Uno — Chupetes
  {
    name: "Blow Pop",
    brand: "Dos en Uno", category: "Chupetes",
    description: "Chupete con centro de chicle en variados sabores frutales.",
    year_introduced: nil, discontinued: false
  },

  # McKay — Galletas
  {
    name: "Kuky",
    brand: "McKay", category: "Galletas",
    description: "Barra de oblea rellena con crema y cubierta de chocolate, un ícono de McKay.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Tritón",
    brand: "McKay", category: "Galletas",
    description: "Galleta sándwich con relleno de crema de vainilla, la versión chilena de la Oreo.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Chocman",
    brand: "McKay", category: "Galletas",
    description: "Galleta sándwich de chocolate con relleno de crema de chocolate.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Óptimus",
    brand: "McKay", category: "Galletas",
    description: "Clásica galleta rectangular de té, ampliamente usada en postres chilenos.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Poker",
    brand: "McKay", category: "Galletas",
    description: "Galletas rectangulares delgadas y crocantes, un básico en los hogares chilenos.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Morocha",
    brand: "McKay", category: "Galletas",
    description: "Oblea de chocolate oscuro rellena con crema de vainilla.",
    year_introduced: nil, discontinued: false
  },

  # Arcor Chile — Chocolates
  {
    name: "Bon o Bon Arcor",
    brand: "Arcor Chile", category: "Chocolates",
    description: "Bolita de chocolate de origen argentino con relleno de crema de maní, popular en Chile.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Cofler",
    brand: "Arcor Chile", category: "Chocolates",
    description: "Barra de chocolate con leche y arroz inflado, fabricada por Arcor.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Rocklets",
    brand: "Arcor Chile", category: "Chocolates",
    description: "Bolitas de chocolate cubiertas de colores, el equivalente chileno de los M&Ms.",
    year_introduced: nil, discontinued: false
  },

  # Arcor Chile — Caramelos
  {
    name: "Butter Toffees Arcor",
    brand: "Arcor Chile", category: "Caramelos",
    description: "Suaves toffees sabor mantequilla en envoltorios dorados.",
    year_introduced: nil, discontinued: false
  },
  {
    name: "Arcor Masticables",
    brand: "Arcor Chile", category: "Caramelos",
    description: "Caramelos blandos y masticables en variados sabores frutales.",
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

# Admin user — credentials from ENV with dev defaults
admin_email    = ENV.fetch("ADMIN_EMAIL", "admin@example.com")
admin_password = ENV.fetch("ADMIN_PASSWORD", "password")

User.find_or_create_by!(email_address: admin_email) do |u|
  u.password = admin_password
  u.admin    = true
end

puts "Done! Seeded #{Brand.count} brands, #{Category.count} categories, #{Candy.count} candies, #{User.count} user(s)."
