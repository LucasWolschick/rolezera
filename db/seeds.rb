# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

[
  [ "bike", "🚲 Bicicletar", "%{user_name} quer dar uma bicicletada. Quer ir junto?" ],
  [ "movies", "🎥 Cinemar", "%{user_name} quer ir ver um filme. Quer ir junto?" ],
  [ "drink", "🍻 Beber", "%{user_name} quer beber. Quer beber junto?" ],
  [ "eat", "🍕 Comer", "%{user_name} estava pensando em sair para comer algo. Quer ir junto?" ],
  [ "buy", "🛍️ Comprar", "%{user_name} quer ir fazer compras. Quer ir junto?" ],
  [ "other", "Qualquer coisa", "%{user_name} quer dar um rolê. Quer ir junto?" ]
].each do |key, topic, prompt|
  EventTopic.find_or_create_by!(key: key, description: topic, prompt: prompt)
end
