module DefaultSigninSpecs
  def make_default_signin_tests(response, user)
    body = JSON.parse(response.body)

    expect(response).to have_http_status(:created)
    expect(body).to include('authentication_token', '_id')
    expect(body['authentication_token']).to eq User.last.authentication_token
    expect(body['authentication_token']).to_not eq user.authentication_token
    expect(body['_id']['$oid']).to eq User.last._id.to_s
  end
end
