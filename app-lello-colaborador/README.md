# Lello App

Um aplicativo criado em Flutter para auxiliar o gerenciamento de condominios da imobiliária Lello.

## Requerimentos

Esse projeto foi implementado utilizando o framework Flutter e para roda-lo se faz necessário te-lo instalado. Para mais informações a respeito da instalação siga os procedimentos encontrados na própria documentação do Flutter:
[Flutter](https://flutter.dev/docs/get-started/install)

Também será necessário a utilização de uma IDE capaz de compilar o framework Flutter. Recomenda-se, segundo a própria documentação do Flutter a utilização do:
   
`InteliJ`
   
ou
   
`Visual Studio Code`

## Como usar:

**1 Passo:**

No terminal navegue até a raiz do projeto e execute o comando abaixo para adcionar todas as dependencias necessárias ao projeto:

```
flutter pub get 

```

**2 Passo:**

Esse projeto trabalha com uma biblioteca de injeção utilizada para geração de código para novas rotas de api utilizadas pelo aplicativo como também novos models para mapeamento das respostas da api. Para gerar novos arquivos:

```
flutter packages pub run build_runner build --delete-conflicting-outputs

```

ou fazer uso do comando para manter o código sincronizado automaticamente:

```
flutter packages pub run build_runner watch

```

## Omitindo arquivos auto-gerados

Para omitir arquivos gerados, basta navegar para `Android Studio` -> `Preferences` -> `Editor` -> `File Types` e colar as linhas a seguir abaixo da seção `ignore files and folders`:

```
*.inject.summary;*.inject.dart;*.g.dart;

```

No Visual Studio Code, basta navegar `Preferences` -> `Settings` e procurar por `Files:Exclude`. Então add os seguintes comandos:

```
**/*.inject.summary
**/*.inject.dart
**/*.g.dart

```

### Estrutura do Código

O código do projeto foi organizado através da arquitetura `Clean` adaptada para a aplicação mobile em conjunto da metodologia `Test Driven Development` TDD para realização de testes automatizados.

```
flutter-app/
|- android
|- assets
|- build
|- ios
|- lang
|- lib
|- test

```

Segue as estrutura das pastas que está sendo utilizada nesse projeto:

```
lib/
|- core/
|- enviroment/
|- feature/
|- ui/

```

Um breve aprofundamento na pasta lib que contem o código principal:

### Core

Todas constantes e widgets comuns a todo o projeto estão nessa pasta. A exemplos das Rotas de Navegação, Database e Validadores em geral.

### Enviroment

Essa pasta contem os arquivos com as variáveis e configurações de ambiente.

### Features

Todas as funcinalidade foram estruturadas utilizando a arquitetura `Clean`. Ou seja cada funcionalidade possui dentro de sua pasta a seguinte estrutura

```
feature/
|- feature_name/
	|- data/
		|- data_source/
		|- model/
		|- repository/
	|- domain
		|- entity
		|- repository
		|- use_cases
	|- presentation
		|- bloc
		|- page
		|- widget

```

### data

É responsável por fazer acesso a dados necessários para popular ou validar as interfaces. Esses dados podem ser providos tanto da cache do próprio aplicativo quanto de fontes externas, vulgo API´s.

### domain

A camada responsável por transitar as informações solicitadas a camada de dados e popular a camada de interface. Além disso contém todas as lógias e regras de negócio da aplicação.

### presentation

Essa pasta contém as interfaces que vão dar vida as experiências de cada funcionalidade. Para o `gerenciamente de estados` da aplicação foi utilizado o `Bloc Pattern`.

### UI

Essa pasta possui todos os temas e widgets utilizados globalmente pela aplicação.

### Testes

A pasta de testes segue a exata mesma estrutura de pastas daquela utilazadas pelo diretório `lib`. É obrigatório a criação das mesmas pastas nos diretórios de testes para que estes funcionem.
Para rodar teste pelo terminal, basta navegar até a raiz do projeto e rodar o comando:
```
flutter test test/counter_test.dart
```

E para mais opções basta consultar as documentações do próprio flutter ou rodar o comando:
```
flutter test --help
```

### Deploy

A build para produção deve ser gerada individualmente tanto no `Android Studio` quanto no `Xcode`. Seguindo os procedimentos padrão de atualização de versão e build e atualizando cada uma das lojas com as informações das novas versões.

Para mais detalhes pertinentes ao deploy da aplicação nas lojas da *AppleStore* e *GooglePlayStore*, confira a documentação do próprio Flutter:
[Documentação para deploy do app iOS](https://flutter.dev/docs/deployment/ios)
[Documentação para deploy do app Android](https://flutter.dev/docs/deployment/android)

