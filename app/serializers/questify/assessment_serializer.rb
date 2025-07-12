class Questify::AssessmentSerializer
  include JSONAPI::Serializer

  attributes :title, :description, :created_at

  attribute :type do |record|
    'assessment'
  end

  has_many :questions, serializer: Questify::QuestionSerializer
end
