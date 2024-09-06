# Teste Prático - Desenvolvedores Mobile Mottu

A arquitetura do teste segue o padrão MVP (Model-View-Presenter), com algumas adaptações.

Usei uma pasta repository para organizar as chamadas à API. A arquitetura foi separada em módulos. O único módulo é o de characters, que contém tudo relacionado aos personagens.

Também criei a pasta core para configurações gerais, como a injeção de dependências, que faço com GetIt. Para navegação, utilizo o Navigator, evitando acoplar tudo ao GetX, que está sendo utilizado apenas para o gerenciamento de estado.

A pasta styles é responsável pelos padrões de estilo, como espaçamento e tipografia, e também poderia ser incluido a paleta de cores e outros componentes reutilizáveis. Os componentes específicos que não serão usados em outras partes do app estão dentro do módulo de characters para manter a organização modular.

Além disso, o cache de dados foi implementado em uma classe que armazena na própria memória RAM e é apagado automaticamente ao fechar o app, sem necessidade de usar Shared Preferences ou outras soluções de armazenamento persistente.

# Description

Um aplicativo onde você pode consultar a lista de personagens da Marvel e suas informações.

## Progresso das Etapas Iniciais:
- [x] Fork do repositório para o Github de forma privada.
- [x] Adicionando usuários: @brunosmm, @BetoMottu, @moreirawebmaster, @jeanchrocha.
- [x] Projeto Flutter criado com package `com.mottu.marvel`.
- [x] Conta criada em developer.marvel.com.
- [x] API KEY gerada e APIs da Marvel consumidas.
- [x] README criado para marcar os itens feitos.
- [x] Build para a plataforma iOS concluída.

## Nível 1 - Branch `level_1`:
- [x] Listagem dos personagens implementada.
- [x] Ação de clique nos cards para exibir detalhes.

## Nível 2 - Branch `level_2`:
- [x] Cache implementado.
- [x] Filtro para a listagem criado.
- [x] Detalhes dos personagens relacionados implementados.

## Nível 3 - Branch `level_3`:
- [x] Splashscreen customizada criada.
- [x] Cache limpo no fechamento do APP.
- [x] Paginação implementada.
- [x] Testes de unidade das regras de negócio criados.
- [x] Clique em personagens relacionados para exibir detalhes.

## Pontos Extras:
- [x] Getx utilizado.
- [x] Firebase Crashlytics configurado.
- [x] Channel em Kotlin criado para capturar mudança de conexão.
- [x] Arquitetura implementada.
