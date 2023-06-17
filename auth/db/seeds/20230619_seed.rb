Sequel.seed(:development, :test) do
  require_relative '../../config/environment'

  def run
    [
      ['Sam', 'first@example.com', 'pass1'],
      ['Pete', 'second@example.com', 'pass2'],
      ['Arnold', 'third@example.com', 'pass3']
    ].each do |name, email, pass|
      user = User.create name: name, email: email, password: pass
      UserSession.create(user_id: user.id)
    end
  end
end
