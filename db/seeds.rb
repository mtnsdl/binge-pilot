# db/seeds.rb

puts "Starting seed process..."

# Clear existing records
puts "Clearing existing records..."
Genre.destroy_all
Mood.destroy_all
puts "Existing records cleared."

# Create Moods
puts "Creating Moods..."
happy_mood = Mood.create!(name: "Happy")
puts "Created Happy Mood with ID: #{happy_mood.id}"
dramatic_mood = Mood.create!(name: "Dramatic")
puts "Created Dramatic Mood with ID: #{dramatic_mood.id}"
thrilling_mood = Mood.create!(name: "Thrilling")
puts "Created Thrilling Mood with ID: #{thrilling_mood.id}"

# Define your genre data
movie_genres = [
  {id: 28, name: "Action"},
  {id: 12, name: "Adventure"},
  {id: 16, name: "Animation"},
  {id: 35, name: "Comedy"},
  {id: 80, name: "Crime"},
  {id: 99, name: "Documentary"},
  {id: 18, name: "Drama"},
  {id: 10751, name: "Family"},
  {id: 14, name: "Fantasy"},
  {id: 36, name: "History"},
  {id: 27, name: "Horror"},
  {id: 10402, name: "Music"},
  {id: 9648, name: "Mystery"},
  {id: 10749, name: "Romance"},
  {id: 878, name: "Science Fiction"},
  {id: 10770, name: "TV Movie"},
  {id: 53, name: "Thriller"},
  {id: 10752, name: "War"},
  {id: 37, name: "Western"}
]

tv_show_genres = [
  {id: 10759, name: "Action & Adventure"},
  {id: 16, name: "Animation"},
  {id: 35, name: "Comedy"},
  {id: 80, name: "Crime"},
  {id: 99, name: "Documentary"},
  {id: 18, name: "Drama"},
  {id: 10751, name: "Family"},
  {id: 10762, name: "Kids"},
  {id: 9648, name: "Mystery"},
  {id: 10763, name: "News"},
  {id: 10764, name: "Reality"},
  {id: 10765, name: "Sci-Fi & Fantasy"},
  {id: 10766, name: "Soap"},
  {id: 10767, name: "Talk"},
  {id: 10768, name: "War & Politics"},
  {id: 37, name: "Western"}
]

# Helper method to seed genres with logging for debugging
def seed_genres(mood, genres, format)
  genres.each do |genre|
    begin
      created_genre = Genre.create!(
        genre_identifier: genre[:id],
        name: genre[:name],
        genre_format: format,
        mood: mood
      )
      puts "Successfully created #{format} genre: #{created_genre.name} with ID: #{created_genre.id}"
    rescue => e
      puts "Error creating genre: #{e.message}"
    end
  end
end

# Seed genres for Happy Mood
puts "Seeding Happy Mood Genres for Movies..."
seed_genres(happy_mood, movie_genres.select { |g| [35, 10751, 10402, 16, 10749].include?(g[:id]) }, 'movie')

puts "Seeding Happy Mood Genres for TV Shows..."
seed_genres(happy_mood, tv_show_genres.select { |g| [35, 10751, 10762, 10764, 16].include?(g[:id]) }, 'tv-show')

# Seed genres for Dramatic Mood
puts "Seeding Dramatic Mood Genres for Movies..."
seed_genres(dramatic_mood, movie_genres.select { |g| [18, 36, 10752, 80].include?(g[:id]) }, 'movie')

puts "Seeding Dramatic Mood Genres for TV Shows..."
seed_genres(dramatic_mood, tv_show_genres.select { |g| [18, 80, 10768, 99].include?(g[:id]) }, 'tv-show')

# Seed genres for Thrilling Mood
puts "Seeding Thrilling Mood Genres for Movies..."
seed_genres(thrilling_mood, movie_genres.select { |g| [28, 12, 53, 9648, 878, 27].include?(g[:id]) }, 'movie')

puts "Seeding Thrilling Mood Genres for TV Shows..."
seed_genres(thrilling_mood, tv_show_genres.select { |g| [10759, 9648, 10765].include?(g[:id]) }, 'tv-show')

puts "Seeding completed successfully!"
