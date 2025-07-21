class Questify::ThemeSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :id, :title, :description, :created_at

  attribute :type do |record|
    'theme'
  end
end
