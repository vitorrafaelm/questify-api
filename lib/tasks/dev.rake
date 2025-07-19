# lib/tasks/dev.rake

namespace :dev do
  desc "Roda um script para testar a criação e associação de todos os modelos principais."
  task test_models: :environment do
    puts "🚀 Iniciando teste completo dos modelos e associações..."

    # --- 1. Preparação: Carregar dados iniciais ---
    puts "\n[ETAPA 1/8] Carregando Professor e Aluno dos seeds..."
    educator = Educator.first
    student = Student.first

    if !(educator && student)
      puts "❌ ERRO: Professor (Educator) ou Aluno (Student) não encontrados."
      puts "👉 Por favor, rode 'rails db:reset' e tente novamente."
      next # Para a tarefa
    end

    begin
      puts "✅ Sucesso! Professor '#{educator.name}' e Aluno '#{student.name}' carregados."

      # --- 2. Testando Theme e Question ---
      puts "\n[ETAPA 2/8] Criando/Encontrando Tema e Questão..."
      theme = Theme.find_or_create_by!(title: "História do Brasil") do |t|
        t.description = "Questões sobre o período colonial."
      end
      question = Question.find_or_create_by!(title: "Descobrimento do Brasil", educator: educator) do |q|
        q.content = "Quem descobriu o Brasil?"
        q.question_type = "descriptive"
        q.is_public = true
      end
      puts "✅ Sucesso! Tema '#{theme.title}' e Questão '#{question.title}' criados/encontrados."

      # --- 3. Testando Associação Many-to-Many ---
      puts "\n[ETAPA 3/8] Associando Questão e Tema..."
      question.themes << theme unless question.themes.include?(theme)
      puts "✅ Sucesso! Associação N-para-N entre Questão e Tema funciona."

      # --- 4. Testando ClassGroup e Associação de Aluno ---
      puts "\n[ETAPA 4/8] Criando/Encontrando Turma e adicionando Aluno..."
      class_group = ClassGroup.find_or_create_by!(class_identifier: "HIST-2025-01", period: "2025.1") do |cg|
        cg.name = "Turma de História 2025"
      end
      class_group.students << student unless class_group.students.include?(student)
      puts "✅ Sucesso! Turma '#{class_group.name}' criada/encontrada e aluno associado."

      # --- 5. Testando Assessment e Associação de Questão ---
      puts "\n[ETAPA 5/8] Criando/Encontrando Avaliação e adicionando Questão..."
      assessment = Assessment.find_or_create_by!(title: "Prova 1 - Brasil Colônia", educator: educator)
      assessment.questions << question unless assessment.questions.include?(question)
      puts "✅ Sucesso! Avaliação '#{assessment.title}' criada/encontrada e questão associada."

      # --- 6. Testando Associação de Avaliação com Turma ---
      puts "\n[ETAPA 6/8] Associando Avaliação com Turma..."
      assessment_to_class_group = AssessmentToClassGroup.find_or_create_by!(
        assessment: assessment,
        class_group: class_group
      ) { |atcg| atcg.due_date = 1.week.from_now }
      puts "✅ Sucesso! Avaliação foi designada para a Turma."

      # --- 7. Testando a Tentativa do Aluno ---
      puts "\n[ETAPA 7/8] Criando/Encontrando registro de tentativa do Aluno..."
      assessment_by_student = AssessmentByStudent.find_or_create_by!(
        student: student,
        assessment_to_class_group: assessment_to_class_group
      ) { |as| as.status = 'in_progress' }
      puts "✅ Sucesso! Registro de tentativa do Aluno criado/encontrado."

      # --- 8. Testando a Resposta do Aluno ---
      puts "\n[ETAPA 8/8] Criando/Encontrando registro de resposta do Aluno..."
      answer = AssessmentAnswer.find_or_create_by!(
        assessment_by_student: assessment_by_student,
        question: question
      ) { |a| a.answer_text = "Pedro Álvares Cabral" }
      puts "✅ Sucesso! Resposta do Aluno foi registrada."

      puts "\n\n🎉🎉🎉 PARABÉNS! Todos os testes foram concluídos com sucesso."

    rescue ActiveRecord::RecordInvalid => e
      puts "\n\n❌ UM ERRO DE VALIDAÇÃO OCORREU: #{e.message}"
      puts "👉 O objeto que falhou foi: #{e.record.inspect}"
    end
  end
end