class Questify::QuestionSerializer
  include JSONAPI::Serializer

  attributes :title, :content, :is_public, :question_type, :created_at

  attribute :type do |record|
    'question'
  end

  has_many :themes, serializer: Questify::ThemeSerializer
  has_many :question_alternatives, serializer: Questify::QuestionAlternativeSerializer
end