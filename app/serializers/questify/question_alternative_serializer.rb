class Questify::QuestionAlternativeSerializer
  include JSONAPI::Serializer
  include SerializerHelper

  attributes :sentence, :is_correct, :question_id

  attribute :type do |record|
    'question_alternative'
  end
end
