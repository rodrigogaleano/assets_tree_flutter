# Assets Tree

Aplicativo Flutter que visualiza a hierarquia de ativos de uma empresa em uma estrutura de árvore.

<img width="250" src="https://github.com/user-attachments/assets/0c1cefed-374a-4296-b84c-e0b252c8543a" />
<img width="250" src="https://github.com/user-attachments/assets/75ae709b-35ca-4510-8e6c-421e7e105f79" />
<img width="250" src="https://github.com/user-attachments/assets/b7434fff-b07d-4d20-a95c-5eb023473d1f" />
<img width="250" src="https://github.com/user-attachments/assets/e8e07db4-d018-453d-9993-33abaeae45f5" />
<img width="250" src="https://github.com/user-attachments/assets/a8d20d40-7764-4783-a490-db32891be6eb" />

## Instalação do Projeto

**Clonando o Repositório**

Abra o terminal e navegue até o diretório onde você deseja clonar o repositório. Em seguida, execute um dos comandos abaixo:

Com SSH

```bash
git@github.com:rodrigogaleano/assets_tree_flutter.git

```

Com HTTPS

```bash
https://github.com/rodrigogaleano/assets_tree_flutter.git
```

**Instalando as Dependências**

Após clonar o repositório, navegue até o diretório do projeto e instale as dependências necessárias:

```bash
cd assets_tree
flutter pub get
```

## Estrutura do Projeto

```
assets_tree/
├── assets/
│   └── data/
│       └── sample.json
├── lib/
│   ├── features/
│   │   ├── sample/
│   │   │   ├── di/
│   │   │   ├── models/
│   │   │   │   └── model.dart
│   │   │   ├── use_cases/
│   │   │   │   └── sample_use_case.dart
│   │   │   └── sample_view.dart
│   │   │   └── sample_view_controller.dart
│   │   │   └── sample_view_model.dart
│   ├── support/
│   │   ├── style/
│   ├── localization/
│   └── router/
├── pubspec.yaml
└── README.md
```

- assets/: Contém arquivos de dados, como JSONs.
- lib/: Contém o código fonte.
- features/sample/: Funcionalidades relacionadas ao exemplo específico.
- di/: Injeção de dependências.
- models/: Modelos de dados utilizados no aplicativo.
- use_cases/: Casos de uso específicos.
- sample_view.dart: View da tela do exemplo.
- sample_view_controller.dart: View Controller da tela do exemplo.
- sample_view_model.dart: ViewModel da tela do exemplo.
- support/: Classes de suporte e utilitários.
- style/: Estilos e temas.
- localization/: Arquivos de tradução.
- router/: Configuração de rotas.
- pubspec.yaml: Arquivo de configuração do Flutter.
- README.md: Este arquivo de documentação.
