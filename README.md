# 🏍️ PitStop - Motorcycle Maintenance & Expense Tracker

![iOS](https://img.shields.io/badge/iOS-17.0+-black?style=flat&logo=apple)
![Swift](https://img.shields.io/badge/Swift-5.9-orange?style=flat&logo=swift)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-blue)

O **PitStop** é um aplicativo iOS nativo focado em ajudar motociclistas a gerenciarem a manutenção de suas motos, acompanhar gastos e receber alertas inteligentes antes que os componentes vençam. 

Este projeto foi construído para demonstrar o uso avançado das tecnologias mais modernas do ecossistema Apple, fugindo do básico e implementando integrações profundas com o iOS.

## ✨ Funcionalidades Principais

* **Garagem Virtual (PhotosUI & SwiftData):** Cadastre motos com fotos diretamente da câmera ou galeria. Os dados são persistidos localmente de forma relacional.
* **Dashboard Financeiro (Charts):** Gráficos interativos nativos que agrupam e analisam os gastos por tipo de serviço (Óleo, Pneu, Relação, etc.).
* **Controle por Voz via Siri (AppIntents):** Atualize a quilometragem da moto sem abrir o app. O sistema possui Internacionalização (i18n), reconhecendo e respondendo nativamente em Inglês e Português dependendo do idioma do iPhone.
* **Home Screen Widget (WidgetKit):** Acompanhe o status da sua moto e a próxima revisão direto da tela inicial. Atualizações em tempo real utilizando `WidgetCenter`.
* **Alertas Inteligentes (UserNotifications):** Ao atualizar a quilometragem (seja manualmente ou pela Siri), o app calcula o desgaste das peças em background e dispara notificações push locais caso algo precise de atenção urgente (ex: faltam menos de 100km).

## 🛠️ Tecnologias e Frameworks Utilizados

O aplicativo foi desenvolvido 100% em **Swift** e **SwiftUI**, utilizando os seguintes frameworks nativos:

* **SwiftData:** Para banco de dados local com relacionamentos (`@Model`, `ModelContainer`, `ModelContext`).
* **WidgetKit:** Criação da extensão de Widget para a tela inicial.
* **AppGroups (`group.*`):** Túnel de segurança criado para compartilhar a base de dados do SwiftData entre o App Principal, o Widget e a Siri em tempo real.
* **AppIntents:** Para criação de *App Shortcuts* automáticos e integração conversacional com a Siri.
* **UserNotifications:** Para agendamento e disparo de alertas baseados em regras de negócio.
* **Charts:** Para a renderização do histórico de gastos em gráficos elegantes.
* **PhotosUI:** Para seleção e conversão de imagens (`PhotosPickerItem` para `Data`).

## 🚀 Como rodar o projeto

1. Clone este repositório:
   ```bash
   git clone [https://github.com/jotape12-Dev/pitstop-app.git](https://github.com/jotape12-Dev/pitstop-app.git)
   ```
2. Abra o arquivo .xcodeproj no Xcode 15 ou superior.

⚠️ Importante (App Groups): Como o projeto utiliza compartilhamento de dados entre Targets, você precisará alterar o Bundle Identifier e configurar o seu próprio App Group nas abas de Signing & Capabilities tanto no alvo PitStop quanto no PitStopWidgetExtension.

Selecione um simulador ou seu iPhone físico e pressione Cmd + R.
