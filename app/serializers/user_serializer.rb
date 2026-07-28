class UserSerializer
  include JSONAPI::Serializer

  set_type :user
  set_id :public_id

  attributes :bgg_username,
    :email,
    :first_name,
    :last_name,
    :username

  attribute :timestamps do |u|
    {
      created_at: u.created_at,
      updated_at: u.updated_at
    }
  end
end
