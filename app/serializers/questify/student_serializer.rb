# frozen_string_literal: true

class Questify::StudentSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :name, :identifier, :institution, :document_type, :document_number, :grande

  attribute :type do |record|
    'student'
  end
end
