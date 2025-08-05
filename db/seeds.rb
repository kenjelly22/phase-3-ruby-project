# frozen_string_literal: true

puts "🌱 Seeding concerts..."

Concert.create(band_name: "AJR", event_date: Date.new(2025, 8, 6), venue: "Freedom Mortgage Pavilion", city: "Camden, NJ")
Concert.create(band_name: "Halestorm", event_date: Date.new(2025, 8, 9), venue: "Freedom Mortgage Pavilion", city: "Camden, NJ")
Concert.create(band_name: "Barnes Courtney", event_date: Date.new(2025, 8, 10), venue: "The Foundry", city: "Philadelphia, PA")
Concert.create(band_name: "The Struts", event_date: Date.new(2025, 8, 23), venue: "The Fillmore", city: "Philadelphia, PA")

puts "🌱 Seeding users..."

User.create(user_name: "Jen Kelly")
User.create(user_name: "Jess Castro")

puts "🌱 Seeding tickets..."

Ticket.create(concert_id: 1, user_id: 1)
Ticket.create(concert_id: 1, user_id: 2)

puts "✅ Done seeding!"
