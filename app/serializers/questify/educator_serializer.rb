# frozen_string_literal: true

class Questify::EducatorSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :name, :identifier, :institution, :document_type, :document_number

  attribute :type do |record|
    'educator'
  end
end
