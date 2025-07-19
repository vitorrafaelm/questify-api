class Questify::ThemeSerializer
  include JSONAPI::Serializer

  attributes :title, :description, :created_at

  attribute :type do |record|
    'theme'
  end
end