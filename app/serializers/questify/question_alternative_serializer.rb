class Questify::QuestionAlternativeSerializer
  include JSONAPI::Serializer

  attributes :sentence, :is_correct

  attribute :type do |record|
    'question_alternative'
  end
end