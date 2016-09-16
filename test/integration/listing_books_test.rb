require 'test_helper'

class ListingBooksTest < ActionDispatch::IntegrationTest

	def setup
		Book.create!(title: 'Progmatic Programmer', rating: 5)
		Book.create!(title: "Ender's game", rating: 4)
	end

	test 'get books' do
		get '/books'

		assert_equal 200, response.status
		assert_equal Mime[:json], response.content_type

		assert_equal Book.count, json(response.body).size
		# assert_equal Book.count, json(response.body)[:books].size
	end

	test 'get top rated books' do
		get '/books?rating=5'

		assert_equal 200, response.status
		assert_equal Mime[:json], response.content_type

		assert_equal 1, json(response.body).size
		# assert_equal 1, json(response.body)[:books].size
	end

end
