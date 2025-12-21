/// This class contains all the App Text in String formats.
///
/// Organized by screen/feature for easy navigation.
/// All user-facing strings should be in Portuguese (pt-BR).
class FinTexts {
  // ═══════════════════════════════════════════════════════════════════════════
  // GLOBAL TEXTS
  // ═══════════════════════════════════════════════════════════════════════════
  static const String and = "and";
  static const String skip = "Pular";
  static const String appName = "Finovate";
  static const String continueText = "Continuar";
  static const String error = "Erro";
  static const String resendCode = "Caso não tenha recebido o código, você poderá solicitá-lo novamente em ";

  // -- Dialog Messages
  static const String dialogErrorTitle = "Erro";
  static const String dialogSuccessTitle = "Sucesso";
  static const String dialogConfirmTitle = "Confirmação";
  static const String dialogInfoTitle = "Informação";
  static const String dialogDismiss = "OK";
  static const String dialogCancel = "Cancelar";
  static const String dialogConfirm = "Confirmar";
  static const String dialogRetry = "Tentar Novamente";
  static const String dialogUnderstood = "Entendi";
  static const String dialogLoadingMessage = "Processando...";


  // -- Onboarding Texts
  static const String onboardingTitle1 = "Acompanhe seus investimentos";
  static const String onboardingTitle2 = "Acompanhe\nindicadores econômicos";
  static const String onboardingTitle3 = "Conheça a SofIA";

  static const String onboardingSubTitle1 = "Tenha uma visão clara do seu dinheiro e tome decisões inteligentes com nossas ferramentas de análise e acompanhamento de investimentos.";
  static const String onboardingSubTitle2 = "Monitore indicadores essenciais e veja como eles impactam sua carteira.\n\nEsteja à frente com decisões baseadas em informações completas.";
  static const String onboardingSubTitle3 = "Nossa inteligência artificial traz análises personalizadas da sua carteira de investimentos, ajudando você a tomar decisões mais seguras e bem informadas sobre o mercado.";

  // -- Get Started Screen
  static const String signIn = "Entrar";
  static const String createAccount = "Criar Conta";

  // -- Login Screen
  static const String loginTitle = "Seja bem vindo!";
  static const String loginSubTitle = "Investimento sem ruído.";
  static const String rememberMe = "Lembre de mim";
  static const String forgetPassword = "Esqueceu a senha?";
  static const String useBiometric = "Usar biometria";
  //Login validation
  static const String loginValidationEmailRequired = "Email é obrigatório";
  static const String loginValidationEmailInvalid = "Digite um email válido";
  static const String loginValidationPasswordRequired = "Senha é obrigatória";
  static const String loginValidationPasswordMinLength = "Senha deve ter pelo menos 6 caracteres";
  //Login messages
  static const String loginSuccessTitle = "Sucesso";
  static const String loginSuccessMessage = "Bem-vindo de volta!";
  static const String loginErrorTitle = "Erro no Login";
  static const String emailHint = "exemplo@email.com";
  // -- Login Error Messages
  static const String loginErrorInvalidCredentials = "Email ou senha incorretos. Por favor, verifique suas credenciais e tente novamente.";
  static const String loginErrorNetworkTitle = "Sem Conexão";
  static const String loginErrorNetwork = "Não foi possível conectar ao servidor. Verifique sua conexão com a internet e tente novamente.";
  static const String loginErrorUnknown = "Ocorreu um erro inesperado. Por favor, tente novamente.";
  //Biometric enrollment
  static const String notNow = "Agora não";
  static const String activate = "Ativar";
  static const String biometricActivatedTitle = "Biometria ativada!";
  static const String biometricActivatedMessage = "Você pode usar";
  static const String biometricActivatedMessageEnd = "no próximo login.";

  // -- Reset password
  static const String resetPasswordEmailError = "Digite um email válido primeiro";
  static const String resetPasswordEmailSentTitle = "Email Enviado";
  static const String resetPasswordEmailSentMessage = "Instruções de redefinição de senha enviadas para seu email";
  // Password Reset Error Messages
  static const String passwordResetErrorUpdate = "Não foi possível atualizar sua senha. Por favor, tente novamente.";
  // Forgot Password Screen
  static const String forgotPasswordTitle = "Esqueceu a senha?";
  static const String forgotPasswordSubtitle = "Digite seu email para redefinir sua senha";
  static const String resetPassword = "Redefinir senha";
  static const String backToLogin = "Voltar ao login";
  static const String forgotPasswordCheckEmailTitle = "Verifique seu email";
  static const String forgotPasswordContinueButton = "Continuar";
  static const String forgotPasswordResendCode = "Reenviar código";

// ═══════════════════════════════════════════════════════════════════════════════════════
// SIGN UP SCREENS
// Text constants for the sign up flow
// ═══════════════════════════════════════════════════════════════════════════════════════
  // -- Sign Up Screen 1
  static const String signupTitle = "Vamos criar a sua conta";
  static const String email = "Email";
  static const String password = "Senha";
  static const String confirmPassword = "Confirmar senha";
  static const String keepInfoSaved = "Manter informações salvas";
  // Privacy disclaimer texts
  static const String privacyAgreement = "Ao continuar, você concorda com a ";
  static const String privacyPolicy = "Política de Privacidade";
  static const String termsOfUse = "Termos de Serviço";
  static const String privacyAgreementEnd = " da Finovate.";

  // -- Sign Up Screen 2
  static const String signupTitle2 = "Informações pessoais";
  static const String signupSubtitle2 = "Conforme os documentos";
  static const String firstName = "Primeiro Nome";
  static const String lastName = "Sobrenome";
  // Disclaimer
  static const String identityDocumentDisclaimer = "Digite seu nome completo exatamente como consta em seu documento de identidade oficial.";

  // -- Sign Up Screen 3
  static const String cpf = "CPF";
  static const String birthDate = "Sua data de nascimento";
  static const String phoneNo = "Numero do seu celular";
  // Disclaimer
  static const String identityDocumentDisclaimer2 = "Digite seu nome completo exatamente como consta em seu documento de identidade oficial.";

  // -- Sign Up Screen 4
  static const String signupTitle3 = "Vamos verificar sua conta";
  static const String verificationCode = "Código de verificação";

// ═══════════════════════════════════════════════════════════════════════════════════════
// ONBOARDING QUESTIONNAIRE
// Text constants for the post-signup questionnaire flow
// ═══════════════════════════════════════════════════════════════════════════════════════

  // Intro Screen (Step 6)
  static const String questionnaireIntroTitle = 'Queremos te conhecer!';
  static const String questionnaireIntroSubtitle =
      'Compartilhe suas preferências de investimento para que possamos oferecer recomendações personalizadas e análises detalhadas para você!';
  static const String questionnaireIntroButton = 'Ok, vamos!';

  // Question 1: Wealth Range
  static const String question1Title = 'Qual é o valor aproximado do seu patrimônio atualmente?';
  static const String question1Option1 = 'Menos de R\$ 50.000';
  static const String question1Option2 = 'De R\$ 50.001 a meio milhão de reais';
  static const String question1Option3 = 'De meio milhão a um milhão de reais';
  static const String question1Option4 = 'Acima de um milhão de reais';
  static const String question1Option5 = 'Prefiro não responder';

  // Question 2: Investment Knowledge
  static const String question2Title = 'Como você avalia seu conhecimento em investimentos e finanças?';
  static const String question2Option1 = 'Ainda estou começando e tenho pouca experiência';
  static const String question2Option2 = 'Tenho algum conhecimento e já adquiri um pouco de experiência';
  static const String question2Option3 = 'Entendo bem do assunto e tenho experiência sólida';
  static const String question2Option4 = 'Tenho conhecimento avançado e ampla experiência';

  // Question 3: Decision Style
  static const String question3Title = 'A quem ou o que você recorre para tomar suas decisões de investimento?';
  static const String question3Option1 = 'Consulto amigos e familiares';
  static const String question3Option2 = 'Pesquiso online, assisto vídeos e utilizo ferramentas financeiras';
  static const String question3Option3 = 'Consulto um assessor financeiro ou minha corretora';
  static const String question3Option4 = 'Tomo decisões por conta própria, com base no meu conhecimento e experiência';

  // Question 4: Risk Profile
  static const String question4Title = 'Qual é o seu perfil de risco?';
  static const String question4Subtitle =
      'O perfil de risco reflete sua disposição para assumir riscos em investimentos, equilibrando a possibilidade de perder com os potenciais ganhos.';
  static const String question4Option1 = 'Prefiro segurança e estabilidade';
  static const String question4Option2 = 'Busco um equilíbrio entre segurança e crescimento';
  static const String question4Option3 = 'Estou disposto a assumir maiores riscos em busca de altos retornos';

  // Final Welcome Screen
  static const String questionnaireWelcomeTitle = 'Seja bem-vindo à Finovate, {NAME}!';
  static const String questionnaireWelcomeSubtitle =
      'Agora é o momento de dar o primeiro passo para investimentos mais inteligentes e alinhados aos seus objetivos.';
  static const String questionnaireWelcomeButton = 'Tudo certo!';

  // Navigation buttons
  static const String questionnaireNextButton = 'Próxima pergunta';
  static const String questionnaireFinalizeButton = 'Finalizar';

  // Error messages
  static const String questionnaireErrorSubmit = 'Erro ao enviar questionário. Tente novamente.';
  static const String questionnaireErrorIncomplete = 'Por favor, selecione uma opção para continuar.';

  // -- Sign Up Final Screen
  static const String signupFinalSubtitle = "Se você trocar seu número ou email no futuro, ajudaremos você a verificar sua conta novamente.";
  static const String signupFinalbutton = "Tudo certo!";

  // -- Signup Process Texts
  static const String signupContinueButton = "Continuar";
  static const String signupFinalizeButton = "Finalizar Cadastro";
  static const String signupValidationEmailRequired = "Email é obrigatório";
  static const String signupValidationEmailInvalid = "Digite um email válido";
  static const String signupValidationPasswordRequired = "Senha é obrigatória";
  static const String signupValidationPasswordMinLength = "Senha deve ter pelo menos 6 caracteres";
  static const String signupValidationConfirmPasswordRequired = "Confirmação de senha é obrigatória";
  static const String signupValidationPasswordsMustMatch = "Senhas não coincidem";
  static const String signupValidationFirstNameRequired = "Primeiro nome é obrigatório";
  static const String signupValidationFirstNameMinLength = "Nome deve ter pelo menos 2 caracteres";
  static const String signupValidationLastNameRequired = "Sobrenome é obrigatório";
  static const String signupValidationLastNameMinLength = "Sobrenome deve ter pelo menos 2 caracteres";
  static const String signupValidationCpfInvalid = "CPF deve ter 11 dígitos";
  static const String signupValidationPhoneInvalid = "Digite um número válido (10-11 dígitos)";
  static const String signupErrorTermsRequired = "Aceite os termos e condições para continuar";
  static const String signupSuccessTitle = "Sucesso";
  static const String signupSuccessMessage = "Conta criada com sucesso!";
  static const String signupErrorTitle = "Erro no Cadastro";

  // Signup Error Messages
  static const String signupErrorEmailExists = "Este email já está cadastrado. Por favor, use outro email ou faça login.";
  static const String signupErrorCpfExists = "Este CPF já está cadastrado. Por favor, verifique seus dados.";
  static const String signupErrorVerificationInvalid = "Código de verificação inválido. Por favor, verifique o código e tente novamente.";
  static const String signupErrorProfileCreation = "Erro ao criar perfil do usuário. Por favor, tente novamente.";
  static const String signupErrorGeneric = "Erro ao criar conta. Por favor, tente novamente.";

  // -- Email Service Error Messages
  static const String emailErrorInvalid = "Email inválido. Verifique se o email está correto e tente novamente.";
  static const String emailErrorNetwork = "Erro de conexão. Verifique sua internet e tente novamente.";
  static const String emailErrorRateLimitTitle = "Aguarde um momento";
  static const String emailErrorRateLimit = "Para sua segurança, aguarde alguns minutos antes de solicitar outro email.";
  static const String emailErrorGeneric = "Erro temporário. Tente novamente em alguns instantes.";

  // -- Biometric Authentication
  static const String biometricPromptTitle = "Desbloqueie o Finovate";
  static const String biometricPromptMessage = "Por favor, autentique-se para continuar";
  static const String biometricPromptUse = "Usar Face ID / Digital";
  static const String biometricPromptSignOut = "Sair";
  static const String biometricAuthReason = "Desbloqueie o Finovate";

  // -- Biometric Error Messages
  static const String biometricErrorActivation = "Não foi possível ativar a biometria. Por favor, tente novamente.";
  static const String biometricErrorNotEnrolled = "Configure a biometria nas configurações do seu dispositivo para continuar.";
  static const String biometricInfoTitle = "Configuração Necessária";

  // -- Session Timeout Messages
  static const String sessionExpiredTitle = "Sessão Expirada";
  static const String sessionExpiredMessage = "Sua sessão expirou por inatividade";
  static const String sessionTimeoutWarning = "Sua sessão expirará em breve";
  static const String extendSession = "Estender Sessão";
  static const String sessionExtended = "Sessão estendida com sucesso";

  // -- SofIA AI Assistant
  static const String sofiaScreenTitle = "SofIA";
  static const String sofiaGreetingHello = "Olá";
  static const String sofiaGreetingQuestion = "como posso ajudar?";
  static const String sofiaDefaultUserName = "Usuário";
  static const String sofiaChatInputHint = "Converse com SofIA";
  static const String sofiaChatInputHintActive = "Digite sua mensagem...";

  // -- SofIA Chat History
  static const String sofiaChatHistory = "Histórico de Chat";
  static const String sofiaViewAllChats = "Ver todos";
  static const String sofiaChatWithSofia = "Conversa com SofIA";

  // SofIA Suggestions
  static const String sofiaSuggestion1 = "Quais ativos apresentaram maior rentabilidade";
  static const String sofiaSuggestion2 = "Quais são as opções com menos risco";
  static const String sofiaSuggestion3 = "Quais ações estão mais descontadas";
  static const String sofiaSuggestion4 = "Perguntas frequentes";

  // SofIA Chat Interface
  static const String sofiaChatEmpty = "Sua conversa aparecerá aqui";
  static const String sofiaErrorRetry = "Tentar novamente";
  static const String sofiaErrorMessage = "Erro ao enviar mensagem. Tente novamente.";
  static const String sofiaChatOptionsTitle = "Opções do Chat";
  static const String sofiaClearChat = "Limpar conversa";
  static const String sofiaClearChatTitle = "Limpar conversa";
  static const String sofiaClearChatMessage = "Tem certeza que deseja limpar toda a conversa? Esta ação não pode ser desfeita.";
  static const String sofiaCancel = "Cancelar";
  static const String sofiaClear = "Limpar";
  static const String sofiaClose = "Fechar";
  static const String sofiaTimeNow = "Agora";

  // SofIA AI Avatar and Interface
  static const String sofiaAIAssistant = "SofIA - Assistente IA";
  static const String sofiaAIDescription = "Converse com nossa IA especializada em investimentos e finanças.";
  static const String sofiaImplementationBadge = "Interface de chat será implementada aqui";
  static const String sofiaMessagePlaceholder = "Digite sua mensagem...";
  static const String sofiaSettingsTooltip = "Configurações do chat";

  // Time formatting
  static const String sofiaTimeMinutesAgo = "m";
  static const String sofiaTimeDaysFormat = "/";
  static const String sofiaTimeHourMinuteSeparator = ":";

  // SofIA AI Mock Responses (for simulation)
  static const String sofiaResponseRentabilidade = "Com base nos dados mais recentes, os ativos com maior rentabilidade incluem REITs imobiliários (+12.5%), ações de tecnologia (+8.3%) e fundos de commodities (+7.8%). Gostaria de mais detalhes sobre algum destes?";
  static const String sofiaResponseRisco = "Para opções com menor risco, recomendo: Tesouro Direto (risco muito baixo), CDBs de grandes bancos (baixo risco) e fundos DI (risco baixo). Estes produtos oferecem segurança com retornos consistentes.";
  static const String sofiaResponseDescontadas = "Analisando o P/L e outros indicadores, algumas ações que estão trading com desconto incluem: VALE3 (P/L 4.2), BBDC4 (P/L 5.1) e PETR4 (P/L 3.8). Importante fazer sua própria análise antes de investir.";
  static const String sofiaResponseFrequentes = "Aqui estão algumas perguntas frequentes:\n\n• Como diversificar minha carteira?\n• Qual a diferença entre ações e FIIs?\n• Como calcular o risco de um investimento?\n• Quando devo rebalancear minha carteira?";
  static const String sofiaResponseDefault = "Entendi sua pergunta sobre investimentos. Como assistente especializada em finanças, posso ajudar com análises de ativos, gestão de risco, e estratégias de investimento. Pode me dar mais detalhes sobre o que você gostaria de saber?";

  // -- Home Screen
  static const String homeErrorTitle = "Erro ao carregar dados";
  static const String homeErrorMessage = "Não foi possível carregar as informações. Verifique sua conexão e tente novamente.";

  // -- Perfil Screen
  static const String perfilScreenTitle = "Meu perfil";
  static const String perfilTabMeuPlano = "Meu plano";
  static const String perfilTabPerfil = "Perfil";
  static const String perfilTabPreferencias = "Preferências";

  // Perfil - Personal Info Fields (Conta tab)
  static const String perfilNomeCompleto = "Nome";
  static const String perfilApelido = "Apelido";
  static const String perfilEmail = "E-mail";
  static const String perfilTelefone = "Número do seu celular";
  static const String perfilCpf = "Seu CPF/CNPJ";
  static const String perfilDataNascimento = "Sua data de nascimento";
  static const String perfilEditar = "Editar";
  static const String perfilSecurityNotice = "Para proteger sua conta, algumas informações são ocultadas.";

  // Perfil - Meu Plano Tab (With Plan)
  static const String perfilPlanoGeral = "Geral";
  static const String perfilPlanoStatus = "Status";
  static const String perfilPlanoStatusActive = "Ativo";
  static const String perfilPlanoComeouEm = "Começou em";
  static const String perfilPlanoProximoPagamento = "Próximo pagamento";
  static const String perfilPlanoPagamento = "Pagamento";
  static const String perfilPlanoPrecoAnual = "Preço anual";
  static const String perfilPlanoMetodo = "Método";
  static const String perfilPlanoMudar = "Mudar meu plano";

  // Perfil - Meu Plano Tab (Without Plan)
  static const String perfilPlanoMaximize = "Maximize seu potencial de investimento.";
  static const String perfilPlanoAssineAgora = "Assine agora";
  static const String perfilPlanoAssineDesc = " e tenha acesso a ferramentas e insights exclusivos.";
  static const String perfilPlanoVerPlanos = "Ver planos";

  // Perfil - Preferências Tab (Geral section)
  static const String perfilGeral = "Geral";
  static const String perfilAparencia = "Aparência";
  static const String perfilAparenciaValue = "Escura";
  static const String perfilBiometria = "Biometria";
  static const String perfilNotificacoes = "Notificações";

  // Perfil - Preferências Tab (Conectividade e suporte section)
  static const String perfilConectividadeSuporte = "Conectividade e suporte";
  static const String perfilContasConectadas = "Contas conectadas";
  static const String perfilConectarB3 = "Conecte sua conta B3 para aproveitar todos os recursos.";
  static const String perfilPoliticaPrivacidade = "Política de privacidade";
  static const String perfilAjuda = "Ajuda";

  // Perfil - Preferências Tab (Notifications messages)
  static const String perfilNotificacoesOff = "Fique por dentro do mercado! Ative as notificações.";
  static const String perfilNotificacoesOn = "Agora você acompanha tudo em tempo real!";

  // Perfil - Actions
  static const String perfilSairConta = "Sair da Conta";
  static const String perfilSairConfirmTitle = "Sair da Conta";
  static const String perfilSairConfirmMessage = "Tem certeza que deseja sair da sua conta?";

  // Common Actions
  static const String save = "Salvar";
  static const String profileUpdated = "Perfil atualizado com sucesso";
  static const String perfilContaVerificada = "Conta Verificada";

  // Email Change
  static const String emailChangeTitle = "Alterar e-mail";
  static const String emailVerifyTitle = "Verificar e-mail";
  static const String emailChangeSubtitle = "Digite seu novo endereço de e-mail";
  static const String emailVerifySubtitle = "Digite o código enviado para";
  static const String emailNewLabel = "Novo e-mail";
  static const String emailOtpLabel = "Código de verificação";
  static const String emailResendCode = "Reenviar código";
  static const String emailResendSuccess = "Código reenviado com sucesso";
  static const String emailSendCode = "Enviar código";
  static const String emailVerify = "Verificar";
  static const String emailBack = "Voltar";

  // Support
  static const String supportEmail = "suporte@finovate.com.br";
  static const String supportEmailSubject = "Ajuda - Finovate App";

  // -- Risk Gauge
  static const String riskLevelLow = "Baixo";
  static const String riskLevelModerate = "Moderado";
  static const String riskLevelHigh = "Alto";
  static const String riskVolatilityLabel = "Volatilidade:";
  static const String riskCalculationExplanation = "Risco calculado com base na volatilidade do período";

  // -- Chart/Data Empty States
  static const String dataNotAvailable = "Dados não disponíveis";
  static const String riskDataNotAvailable = "Dados de risco não disponíveis";

  // -- Stocks Screen
  static const String stocksScreenTitle = "Ações";
  static const String stocksSearchPlaceholder = "Encontre uma ação ou empresa";
  static const String stocksFilterAll = "Todas";
  static const String stocksFilterTopGainers = "Maiores altas";
  static const String stocksFilterTopLosers = "Maiores baixas";
  static const String stocksEmptyTitle = "Nenhuma ação encontrada";
  static const String stocksEmptySubtitle = "Tente buscar por outro termo";
  static const String stocksPaginationPrevious = "Anterior";
  static const String stocksPaginationNext = "Próxima";
  static const String stocksPaginationPage = "Página";
  static const String stocksPaginationOf = "de";

  // -- Stock Detail Screen
  static const String stockDetailChartTitle = "Gráfico do histórico de preços";
  static const String stockDetailLastUpdate = "Última atualização:";
  static const String stockDetailAboutCompany = "Sobre a empresa";
  static const String stockDetailIndicators = "Indicadores financeiros";
  static const String stockDetailIndicatorsInfo = "Os indicadores financeiros ajudam a avaliar a saúde financeira e o desempenho de uma empresa. Use-os para comparar empresas do mesmo setor.";
  static const String stockDetailSeeMore = "Ver mais";
  static const String stockDetailSeeLess = "Ver menos";
  static const String stockDetailFavoriteAdded = "Ação adicionada aos favoritos.";
  static const String stockDetailFavoriteRemoved = "Ação retirada dos favoritos.";
  static const String stockDetailLoadError = "Erro ao carregar dados da ação";
  static const String stockDetailChartInfoTitle = "Gráfico de Preços";
  static const String stockDetailChartInfoDescription = "Arraste o dedo sobre o gráfico para ver o preço e a data em diferentes pontos no tempo.";
}