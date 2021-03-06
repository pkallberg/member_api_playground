Warden::Manager.serialize_into_session { |user| user.id }
Warden::Manager.serialize_from_session { |id| User.find(id) }

Warden::Manager.before_failure do |env,opts|
  env['REQUEST_METHOD'] = 'POST'
end

Warden::Strategies.add(:password) do

  def valid?
    params['email'] || params['password']
  end

  def authenticate!
    user = User.where(email: params["email"]).first
    if user && user.authenticate(params["password"])
      success!(user)
    else
      fail!("Could not log in")
    end
  end

  # def authenticate!
  #   u = User.authenticate(params['email'], params['password'])
  #   u.nil? ? fail!("Could not log in") : success!(u)
  # end
end