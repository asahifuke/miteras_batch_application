class User
  def initialize(username, password, session)
    @session = session
    @username = username
    @password = password
  end

  def login
    @session.navigate.to "https://kintai.miteras.jp/A319971/login"
    @session.find_element(:id, 'username').send_keys(@username)
    @session.find_element(:id, 'password').send_keys(@password, :enter)
    sleep(1)
  end
end