# frozen_string_literal: true

class Questify::StudentSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :name, :identifier, :institution, :document_type, :document_number, :grade

  attribute :type do |record|
    'student'
  end
end
