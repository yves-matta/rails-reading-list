require 'test_helper'

class ListingBooksTest < ActionDispatch::IntegrationTest

	def setup
		@scifi = Genre.create!(name: 'Programming')

		@scifi.books.create!(title: 'Star Trek', rating: 5)
		@scifi.books.create!(title: "Ender's game", rating: 4)
	end

	test 'get books' do
		get '/books'

		assert_equal 200, response.status
		assert_equal Mime[:json], response.content_type

		books = json(response.body)
		assert_equal Book.count, books.size
		# assert_equal Book.count, json(response.body)[:books].size

		book = Book.find(books.first[:id])
		assert_equal @scifi.id, book.genre.id
	end

	test 'get top rated books' do
		get '/books?rating=5'

		assert_equal 200, response.status
		assert_equal Mime[:json], response.content_type

		assert_equal 1, json(response.body).size
		# assert_equal 1, json(response.body)[:books].size
	end

end
