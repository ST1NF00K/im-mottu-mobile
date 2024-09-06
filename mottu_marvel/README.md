# Teste Prático - Desenvolvedores Mobile Mottu

A arquitetura do teste segue o padrão MVP (Model-View-Presenter), com algumas adições para melhorar a organização do código.

No MVP, a lógica de apresentação é separada da lógica de negócios e da interface do usuário. O Presenter atua como um intermediário entre a View e o Model, garantindo que a interface do usuário não precise lidar diretamente com a lógica de dados.

Além do padrão MVP, também adicionei uma pasta repository, que é responsável por fazer as chamadas à API e centralizar o acesso a dados, permitindo que o Presenter trabalhe com dados sem se preocupar com a forma como eles são obtidos. Essa estrutura foi separada em módulos, sendo que atualmente só temos o módulo de characters, onde todas as funcionalidades relacionadas a personagens são implementadas.

Na estrutura do app, também existe a pasta core, que lida com configurações gerais, como injeção de dependências e outras definições globais que afetam o aplicativo como um todo. Essa pasta centraliza funcionalidades que não estão vinculadas diretamente a um módulo específico.

Por fim, há a pasta styles, que gerencia os padrões visuais da aplicação, como espaçamentos e tipografia. Poderíamos adicionar a ela a paleta de cores e componentes visuais reutilizáveis. No entanto, optei por manter os outros componentes relacionados exclusivamente ao módulo de characters dentro desse próprio módulo, pois não são reaproveitáveis em outras áreas do aplicativo.

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
