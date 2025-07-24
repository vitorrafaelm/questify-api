permission_data = [
  { name: 'Criar temas de questões', identifier: 'create-questions-themes', object_type: 'tests-and-questions' },
  { name: 'Criar questões', identifier: 'create-questions', object_type: 'tests-and-questions' }, 
  { name: 'Criar testes', identifier: 'create-assessments', object_type: 'tests-and-questions' }, 
  { name: 'Ver questões', identifier: 'view-questions-student', object_type: 'tests-and-questions' }, 
  { name: 'Ver testes', identifier: 'view-test-student', object_type: 'tests-and-questions' },
]
  permission_data.each do |data|
  PermissionObject.find_or_create_by!(identifier: data[:identifier]) do |permission|
    permission.name = data[:name]
    permission.object_type = data[:object_type]
  end
end

puts "Objetos de permissão (PermissionObject) criados/atualizados."

puts "Iniciando criação de usuários de teste com suas permissões padrão..."

  # --- Educador de Teste ---
  professor_doc_number = "12345678900"
  professor_email = "professor@example.com"
  professor_password = "Password132#" 

  professor = Educator.find_or_create_by!(document_number: professor_doc_number) do |e|
    e.name = "Professor Principal"
    e.institution = "Minha Instituição Educacional"
    e.document_type = "CPF"
  end

  unless professor.user_authorization.present?
    UserAuthorization.create!(
      email: professor_email,
      password: professor_password,
      password_confirmation: professor_password,
      user_authorizable: professor,
      state: :active
    )
    puts "UserAuthorization para Professor Principal criada e permissões padrão atribuídas."
  else
    puts "UserAuthorization para Professor Principal já existe. Permissões devem estar atribuídas."
  end

  # --- Estudante de Teste ---
  aluno_doc_number = "98765432100"
  aluno_email = "aluno@example.com"
  aluno_password = "Password132#"

  aluno = Student.find_or_create_by!(document_number: aluno_doc_number) do |s|
    s.name = "Aluno Padrão"
    s.username = "alunoPadrao"
    s.institution = "Minha Instituição Educacional"
    s.document_type = "CPF"
    s.grade = "1"
  end

  unless aluno.user_authorization.present?
    UserAuthorization.create!(
      email: aluno_email,
      password: aluno_password,
      password_confirmation: aluno_password,
      user_authorizable: aluno,
      state: :active
    )
    puts "UserAuthorization para Aluno Padrão criada e permissões padrão atribuídas."
  else
    puts "UserAuthorization para Aluno Padrão já existe. Permissões devem estar atribuídas."
  end

  puts "Geração de usuários de teste com permissões finalizada."