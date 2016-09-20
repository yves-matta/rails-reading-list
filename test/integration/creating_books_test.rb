require 'test_helper'

class CreatingBooksTest < ActionDispatch::IntegrationTest
	def setup
		@scifi = Genre.create!(name: "Programming")
	end
	test 'create books with valid data' do
		post '/books',
		{ params: {
				book: {
					title: 'Pragmatic Programmer',
					rating: 5,
					author: 'Yves Matta',
					genre_id: @scifi.id,
					review: 'Excellent book for a programmer',
					amazon_id: '13213'
				}
			}.to_json,
			headers: { 'Accept' => 'application/json',
				'Content-Type' => 'application/json'} }
		
		assert_equal 201, response.status
		assert_equal Mime[:json], response.content_type
		book = json(response.body)
		# book = json(response.body)[:book]
		assert_equal book_url(book[:id]), response.location

		assert_equal 'Pragmatic Programmer', book[:title]
		assert_equal 5, book[:rating].to_i
		assert_equal 'Yves Matta', book[:author]
		assert_equal @scifi.id, book[:genre_id]
		assert_equal 'Excellent book for a programmer', book[:review]
		assert_equal '13213', book[:amazon_id]
	end

	test 'does not create books with invalid data' do
		post '/books',
		{ params: {
				book: {
					title: nil,
					rating: 5
				}
			}.to_json,
			headers: { 'Accept' => 'application/json',
				'Content-Type' => 'application/json'} }

		assert_equal 422, response.status
	end
end
