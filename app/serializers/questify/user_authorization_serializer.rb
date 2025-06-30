class Questify::UserAuthorizationSerializer
  include FastJsonapi::ObjectSerializer
  include SerializerHelper

  attributes :identifier, :email
end
