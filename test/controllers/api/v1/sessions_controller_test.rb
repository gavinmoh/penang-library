require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test 'Should sign_up and login' do
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }

    post '/api/v1/sign_up', headers: headers, params: {
      user: {
        email: 'login@test.com',
        password: '123456',
        name: 'login test'
      }
    }.to_json

    assert_response 200
    assert_equal('login@test.com', JSON.parse(response.body)['data']['user']['email'])

    post '/api/v1/login', headers: headers, params: {
      user: {
        email: 'login@test.com',
        password: '123456'
      }
    }.to_json

    assert_response 200
    assert_equal('Login success!', JSON.parse(response.body)['message'])
    assert_not_nil(response.header['Authorization'])

  end

end
