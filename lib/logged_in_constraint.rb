class LoggedInConstraint < Struct.new(:value)
  def matches?(request)
    request.cookies.key?('tg_auth_token') == value
  end
end