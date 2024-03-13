puts "Starting seed process..."
puts "Deleting Users"
User.destroy_all

puts "Creating Users 🤷🏽‍♂️🤷🏽‍♂️🤷🏽‍♂️🤷🏽‍♂️🤷🏼‍♀️"
alfonso = User.create(first_name: "Alfonso", last_name: "Xavier", email: "alfonso@alfonso.com", password: "123456")
User.create(first_name: "Tonno", last_name: "Tonno", email: "tonno@tonno.com", password: "123456")
User.create(first_name: "Vio", last_name: "Vio", email: "vio@vio.com", password: "123456")
User.create(first_name: "Martin", last_name: "Martin", email: "martin@martin.com", password: "123456")
User.create(first_name: "Emma", last_name: "Rünzel", email: "emma@test.com", password: "123456")

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

# Seed genres for Movies Happy Mood
puts "Seeding Happy Mood Genres for Movies..."
seed_genres(happy_mood, movie_genres.select { |g| [35, 10751, 10402, 16, 10749, 10402, 10770].include?(g[:id]) }, 'movie')

# Seed genres for Movies Dramatic Mood
puts "Seeding Dramatic Mood Genres for Movies..."
seed_genres(dramatic_mood, movie_genres.select { |g| [18, 36, 10752, 80, 99].include?(g[:id]) }, 'movie')

# Seed genres for Movies Thrilling Mood
puts "Seeding Thrilling Mood Genres for Movies..."
seed_genres(thrilling_mood, movie_genres.select { |g| [28, 12, 53, 9648, 878, 27, 14, 37].include?(g[:id]) }, 'movie')

# Seed genres for TVShows Happy Mood
puts "Seeding Happy Mood Genres for TV Shows..."
seed_genres(happy_mood, tv_show_genres.select { |g| [35, 10751, 10762, 10764, 16, 10767].include?(g[:id]) }, 'tv')

# Seed genres for TVShows Dramatic Mood
puts "Seeding Dramatic Mood Genres for TV Shows..."
seed_genres(dramatic_mood, tv_show_genres.select { |g| [18, 80, 10768, 99, 10763, 10766].include?(g[:id]) }, 'tv')

# Seed genres for TVShows Thrilling Mood
puts "Seeding Thrilling Mood Genres for TV Shows..."
seed_genres(thrilling_mood, tv_show_genres.select { |g| [10759, 9648, 10765, 10768, 37].include?(g[:id]) }, 'tv')

# Bookmarks
Bookmark.destroy_all
Content.destroy_all

shaw = Content.create!(name: "The Shawshank Redemption", picture_url: "https://i.ebayimg.com/images/g/XxMAAOSw~zFg4aCs/s-l1600.jpg", type: nil, content_identifier: 278)
Bookmark.create!(user: alfonso, status_like: "liked", status_watch: nil, offered: true, content_id: shaw.id)

puts "#{Bookmark.count} bookmark created."
puts "Seeding completed successfully! 🌱"
