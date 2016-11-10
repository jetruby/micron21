helpers do
  def protected!
    return if authorized?
    halt 401
  end

  def extract_token
    request.env['HTTP_ACCESS_TOKEN']
  end

  def authorized?
    @token = extract_token

    decoded_token, headers = JWT.decode @token, nil, false

    decoded_token['success']
  rescue JWT::DecodeError => e
    return false
  end
end
