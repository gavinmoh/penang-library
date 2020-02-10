require 'test_helper'
require 'devise/jwt/test_helpers'

class Api::V1::BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @one = books(:one)
    @two = books(:two)
    @three = books(:three)
    @four = books(:four)
    @librarian = users(:librarian)
    @patreon = users(:patreon)
    @t_two = transactions(:t_two)
  end

  test 'Should add book' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @librarian)

    assert_difference('Book.count') do
      post '/api/v1/books', headers: auth_headers, params: {
        book: {
          title: 'Ruby on Rails',
          author: 'David Heinemeier Hansson',
          published_year: '2004',
          serial_number: '123456789',
          genre: 'Programming'
        }
      }.to_json
    end

    assert_response 200
    assert_equal('Ruby on Rails', JSON.parse(response.body)['data']['title'])
  end

  test 'Should not add book' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @patreon)

    post '/api/v1/books', headers: auth_headers, params: {
      book: {
        title: 'Ruby on Rails',
        author: 'David Heinemeier Hansson',
        published_year: '2004',
        serial_number: '123456789',
        genre: 'Programming'
      }
    }.to_json

    assert_response 401
  end

  test 'Should update book' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @librarian)

    put "/api/v1/books/#{@one.id}", headers: auth_headers, params: {
      book: {
        title: 'Harry Potter'
      }
    }.to_json

    assert_response 200
    assert_equal('Harry Potter', JSON.parse(response.body)['data']['title'])
  end

  test 'Should not update book' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @patreon)

    put "/api/v1/books/#{@one.id}", headers: auth_headers, params: {
      book: {
        title: 'Harry Potter'
      }
    }.to_json

    assert_response 401
  end

  test 'Should show book and status' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    get "/api/v1/books/#{@one.id}"

    assert_response 200
    assert_equal('Harry Potter and the Deathly Hallows', JSON.parse(response.body)['data']['title'])
    assert_equal('AVAILABLE', JSON.parse(response.body)['data']['status'])
  end

  test 'Should show status checked_out' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    get "/api/v1/books/#{@two.id}"

    assert_response 200
    assert_equal('CHECKED_OUT', JSON.parse(response.body)['data']['status'])
  end

  test 'Should checkout' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @patreon)

    assert_difference('Transaction.count') do
      post "/api/v1/books/#{@one.id}/checkout", headers: auth_headers
    end

    assert_response 200
    assert_equal(@one.id, JSON.parse(response.body)['data']['book_id'])
    assert_equal(@patreon.id, JSON.parse(response.body)['data']['user_id'])
  end

  test 'Should checkin' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @patreon)

    put "/api/v1/books/#{@two.id}/checkin", headers: auth_headers

    assert_response 200
    assert_equal(@t_two.id, JSON.parse(response.body)['data']['id'])
  end

  test 'Should not checkout' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @patreon)

    post "/api/v1/books/#{@two.id}/checkout", headers: auth_headers

    assert_response 422
  end

  test 'Should not checkin' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @patreon)

    put "/api/v1/books/#{@one.id}/checkin", headers: auth_headers

    assert_response 422
  end

  test 'Cannot checkout' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }

    post "/api/v1/books/#{@one.id}/checkout"

    assert_response 401
  end

  test 'Cannot checkin' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }

    put "/api/v1/books/#{@two.id}/checkin"

    assert_response 401
  end

  test 'Should destroy' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @librarian)

    assert_difference('Book.count', -1) do
      delete "/api/v1/books/#{@three.id}", headers: auth_headers
    end

    assert_response 200
  end

  test 'Should not destroy' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, @patreon)

    assert_no_difference('Book.count') do
      delete "/api/v1/books/#{@three.id}", headers: auth_headers
    end

    assert_response 401
  end

  test 'Should get index' do
    get '/api/v1/books'

    assert_response 200
    assert_not_nil assigns(:books)
  end

  test 'Should show search result' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    get '/api/v1/books/search?title=harry', headers: headers

    assert_response 200
    assert_equal(@one.title, JSON.parse(response.body)['data'][0]['title'])
    assert_equal(@four.title, JSON.parse(response.body)['data'][1]['title'])
  end

end
