# CollectionProject iOS

App iOS (SwiftUI) para gerenciar colecao pessoal e fluxo de emprestimos.

## Status Atual

- Integrado com backend REST
- Arquitetura MVVM com camada de servicos
- App em modo API-only (sem mocks no target principal)
- Testes unitarios e de ViewModel no target de testes

## Funcionalidades

- Cadastro e listagem de itens (game, book, movie, boardgame, other)
- Cadastro e listagem de amigos
- Emprestar item para um amigo
- Marcar emprestimo como devolvido
- Historico de emprestimos por item

## Arquitetura

- UI: SwiftUI
- Padrao: MVVM
- Networking: `APIClient` com `async/await`
- Servicos:
	- `ItemAPIService`
	- `FriendAPIService`
	- `LoanAPIService`
- Dependencias centrais em `AppDependencies`

Observacao sobre datas de emprestimo no app:
- `returnDate` representa data prevista de devolucao
- `returnedAt` representa data real de devolucao

## Estrutura Principal

```
CollectionAndLoan/
├── CollectionProject/
│   ├── CollectionProject/
│   │   ├── Models/
│   │   ├── Services/
│   │   ├── ViewModels/
│   │   ├── Views/
│   │   ├── AppDependencies.swift
│   │   └── CollectionProjectApp.swift
│   ├── CollectionProject.xcodeproj/
│   ├── CollectionProjectTests/
│   └── CollectionProjectUITests/
└── README.md
```

## Requisitos

- macOS com Xcode instalado
- iOS Simulator
- Backend local rodando em `http://127.0.0.1:3000`

## Como Rodar

1. Suba sua API REST local.
2. Abra `CollectionProject.xcodeproj` no Xcode.
3. Selecione um simulator (ex: iPhone 17).
4. Execute o app (`Cmd + R`).

## Configuracao de API

- Base URL configurada em `Services/APIClient.swift`
- Token Bearer de desenvolvimento configurado em `AppDependencies.swift`

Se o token expirar ou mudar, atualize o valor em `AppDependencies.swift`.

## Testes

Executar somente testes unitarios:

```bash
xcodebuild test \
	-scheme CollectionProject \
	-destination 'platform=iOS Simulator,name=iPhone 17,OS=26.3.1' \
	-only-testing:CollectionProjectTests
```

Executar suite completa (inclui UI Tests):

```bash
xcodebuild test \
	-scheme CollectionProject \
	-destination 'platform=iOS Simulator,name=iPhone 17,OS=26.3.1'
```

## Troubleshooting Rapido

- Itens nao aparecem:
	- confirme API no ar e token valido
	- valide logs `[API]` no console do app
- Botao de devolucao nao aparece:
	- confirme `GET /loans?item_id=...` retornando emprestimo com `returned_at: null`
	- confirme status do item como `lent`
- Erro de rede no simulator:
	- confirme backend escutando em `127.0.0.1:3000`

## Proximos Passos

- Login real no app e armazenamento seguro de token
- Mais testes de integracao fim a fim com API
- Melhorias de UX para estados de carregamento/erro