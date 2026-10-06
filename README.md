# 🧾 BookBank

<div align="center">

**A beautiful and comprehensive personal finance management application**

![App Icon](./lib/core/icons/BookBank_Logo%203.png)

[![Flutter](https://img.shields.io/badge/Flutter-3.12+-02569B?logo=flutter)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web%20%7C%20Desktop-lightgrey)](https://flutter.dev/multi-platform)

</div>

---

## ✨ Features

### 📊 **Dashboard**
- **Total Balance Overview**: Track your complete financial picture at a glance
- **Bank & Cash Management**: Separate tracking for different money positions
- **Income & Expense Summary**: Monthly financial summaries with trends
- **Unallocated Funds**: Visual representation of unassigned money
- **Interactive Group Cards**: Drag-and-drop transfers between groups
- **Real-time Statistics**: Live updates as you add transactions

### 💰 **Transaction Management**
- **Multiple Transaction Types**: Income, Expense, and Transfer support
- **Category System**: Customizable spending categories (4 groups)
- **Date Selection**: Easy date picker for transaction records
- **Quick Entry**: Fast and intuitive transaction adding interface
- **Transfer Mode**: Seamless money transfers between accounts/groups

### 📈 **Charts & Analytics**
- **Daily Statistics**: View your daily income, expenses, and net balance
- **Monthly Trends**: Track spending patterns throughout the month
- **Yearly Overview**: Annual financial analysis with category breakdowns
- **Pie Charts**: Visual category expense distribution
- **Line Charts**: Historical spending trends over time
- **Interactive Filtering**: Filter by date range and category

### 📝 **Notebook**
- **Personal Notes**: Create and manage personal notes and reminders
- **Color Coding**: Organize notes with custom color tags
- **Categories**: Categorize notes (General, Finance, Goals, etc.)
- **Pinning**: Pin important notes for quick access
- **Search Functionality**: Find notes quickly with search
- **Multi-select**: Bulk operations on notes

### 🌐 **Localization**
- **Multi-language Support**: Thai, English, and Chinese
- **Currency Options**: Thai Baht (฿), US Dollar ($), Chinese Yuan (¥)
- **Easy Switching**: Change language and currency anytime

### 🎨 **User Experience**
- **Dark/Light Theme**: Beautiful theme switching with persistence
- **Responsive Design**: Optimized for mobile, tablet, and desktop
- **Material Design 3**: Modern and intuitive UI
- **Smooth Animations**: Fluid transitions and interactions
- **Onboarding**: Guided setup for new users

### � **Privacy & Security**
- **Local Storage**: All data stored locally on your device
- **No Cloud Dependency**: Your financial data never leaves your device
- **Privacy Policy**: Transparent data handling practices

---

## 🛠️ Tech Stack

### Core Technologies
- **[Flutter](https://flutter.dev/)** - Cross-platform UI framework
- **[Dart](https://dart.dev/)** - Programming language
- **[SQLite](https://www.sqlite.org/)** - Local database storage

### State Management
- **[Provider](https://pub.dev/packages/provider)** - State management solution

### Data Persistence
- **[sqflite](https://pub.dev/packages/sqflite)** - SQLite database operations
- **[shared_preferences](https://pub.dev/packages/shared_preferences)** - Settings persistence

### UI Components
- **[fl_chart](https://pub.dev/packages/fl_chart)** - Beautiful charts and graphs
- **[flutter_screenutil](https://pub.dev/packages/flutter_screenutil)** - Responsive design utilities
- **[responsive_framework](https://pub.dev/packages/responsive_framework)** - Breakpoint management

### Utilities
- **[intl](https://pub.dev/packages/intl)** - Internationalization and date formatting
- **[cupertino_icons](https://pub.dev/packages/cupertino_icons)** - iOS-style icons

---

## 🗂️ Project Structure

```text
lib/
│
├── core/                                           # Core components and infrastructure
│   ├── fonts/                                      # Custom font files (ADLaMDisplay)
│   ├── icons/                                      # App logos and icons
│   ├── images/                                     # Background and illustration images
│   ├── theme/                                      # Color themes and typography
│   │    └── app_theme.dart                         # Light/Dark theme definitions
│   └── localization/                               # Internationalization system (i18n)
│        ├── app_localizations.dart                 # Translation strings (TH/EN/CN)
│        └── localization_provider.dart             # Language state management
│
├── data/                                           # Data layer
│    ├── database.dart                              # Data models (MyData, GroupSettings, NoteModel)
│    └── db_helper.dart                             # SQLite database operations
│
├── features/                                       # Feature-based architecture
│    ├── add_transaction/                           # Transaction entry feature
│    │    ├── add_transaction_screen.dart           # Main transaction screen
│    │    └── widgets/                              # Transaction sub-components
│    │         ├── amount_input.dart                # Amount input with validation
│    │         ├── category_selector.dart           # Category/group selection
│    │         ├── header.dart                      # Screen header
│    │         ├── list_button.dart                 # Quick list access
│    │         ├── position_selector.dart           # Bank/Cash position selector
│    │         ├── save_button.dart                 # Save transaction button
│    │         ├── title_input.dart                 # Transaction title input
│    │         ├── transfer_mode.dart               # Transfer between accounts
│    │         └── type_selector.dart               # Income/Expense/Transfer selector
│    │
│    ├── charts/                                    # Analytics and visualization
│    │    ├── chart_screen.dart                     # Main charts screen
│    │    └── widgets/                              # Chart components
│    │         ├── _build_summary_item.dart          # Summary item builder
│    │         ├── category_pie_chart.dart          # Category distribution pie chart
│    │         ├── daily_summary_card.dart          # Daily statistics card
│    │         ├── monthly_chart.dart               # Monthly trend line chart
│    │         └── yearly_chart.dart                # Yearly overview chart
│    │
│    ├── home/                                      # Dashboard feature
│    │    ├── home_screen.dart                      # Main dashboard screen
│    │    ├── popup/                                # Interactive popups
│    │    │    ├── popup_group.dart                 # Group details popup
│    │    │    ├── popup_group_unallocated.dart     # Group unallocated amount
│    │    │    ├── popup_main.dart                  # Main action popup
│    │    │    ├── popup_unallocated.dart           # Unallocated funds popup
│    │    │    └── transfer_popup.dart              # Transfer between groups
│    │    └── widgets/                              # Dashboard components
│    │         ├── dashboard_summary.dart           # Total balance summary
│    │         ├── group_card.dart                  # Interactive group card
│    │         ├── unallocated_bar.dart             # Unallocated progress bar
│    │         ├── unallocated_number.dart          # Unallocated amount display
│    │         └── unallocated_summary.dart         # Unallocated summary widget
│    │
│    ├── menu/                                      # Settings and configuration
│    │    ├── about/                                # About and legal
│    │    │    ├── about_screen.dart                 # About developer screen
│    │    │    └── privacy_policy_dialog.dart       # Privacy policy dialog
│    │    └── edit_group/                           # Group management
│    │         ├── edit_group_screen.dart           # Group settings screen
│    │         ├── group_edit_dialog.dart           # Group edit dialog
│    │         └── providers/                       # Group settings state
│    │              └── group_settings_provider.dart
│    │
│    ├── notebook/                                  # Note-taking feature
│    │    ├── notebook_screen.dart                  # Main notebook screen
│    │    ├── providers/                            # Note state management
│    │    │    └── note_provider.dart
│    │    └── widgets/                              # Notebook components
│    │         ├── empty_notes_view.dart            # Empty state view
│    │         ├── note_card.dart                   # Note card widget
│    │         ├── note_editor_dialog.dart          # Note creation/editing
│    │         └── note_search_bar.dart             # Search functionality
│    │
│    ├── onboarding/                                # First-time user experience
│    │    ├── onboarding_page_1.dart                # Welcome screen
│    │    ├── onboarding_page_2.dart                # Language/currency selection
│    │    └── providers/                            # Onboarding state
│    │         └── onboarding_provider.dart
│    │
│    └── records/                                   # Transaction history
│         ├── record_screen.dart                    # Records list screen
│         ├── utils/                                # Record utilities
│         │      ├── record_actions.dart            # CRUD operations
│         │      ├── record_date_filter.dart        # Date range filtering
│         │      ├── record_filter.dart             # Record filtering logic
│         │      └── record_utils.dart              # Helper functions
│         └── widgets/                              # Record UI components
│              ├── record_card.dart                 # Transaction card
│              └── record_widgets.dart              # Additional widgets
│
├── utils/                                          # Utility functions
│    └── calculations.dart                          # Financial calculations engine
│
├── widgets/                                        # Reusable UI widgets
│    ├── header.dart                                # App header component
│    ├── inWell.dart                                # Date picker wrapper
│    ├── lieChart.dart                              # Line chart component
│    └── navigation_bar.dart                        # Bottom navigation bar
│
└── main.dart                                       # Application entry point

```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.12.0 or higher)
- Dart SDK (3.12.0 or higher)
- Android Studio / Xcode (for mobile development)
- VS Code or Android Studio (recommended IDE)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/bookbank.git
   cd bookbank
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For mobile
   flutter run

   # For web
   flutter run -d chrome

   # For desktop
   flutter run -d windows
   flutter run -d macos
   flutter run -d linux
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release

# Desktop
flutter build windows --release
flutter build macos --release
flutter build linux --release
```

---

## 📱 Screenshots

### Dashboard
- Total balance overview with bank/cash breakdown
- Interactive group cards with drag-and-drop transfers
- Monthly income/expense summary
- Unallocated funds visualization

### Transaction Management
- Quick add transaction interface
- Income/Expense/Transfer mode switching
- Category and position selection
- Date picker for transaction records

### Charts & Analytics
- Daily statistics with category breakdown
- Monthly trend charts
- Yearly financial overview
- Interactive pie charts for spending analysis

### Notebook
- Note cards with color coding
- Search and filter functionality
- Note editing dialog
- Pin and category organization

---

## 🎯 Key Features Explained

### Group System
The app uses a 4-group system for organizing expenses:
- **Group 1**: Default blue color, customizable
- **Group 2**: Default orange color, customizable
- **Group 3**: Default purple color, customizable
- **Group 4**: Default pink color, customizable

Each group can have:
- Custom name
- Custom icon (20+ options)
- Custom color
- Savings goal (optional)

### Transfer System
- **Account Transfers**: Move money between Bank and Cash
- **Group Transfers**: Drag-and-drop to transfer between groups
- **Visual Feedback**: Progress indicators and confirmation dialogs

### Data Models

#### MyData (Transaction)
```dart
- id: Unique identifier
- amount: Transaction amount
- moneyList: Bank or Cash
- moneyType: Income, Expense, or Transfer
- moneyGroup: Category group (Group1-4)
- date: Transaction date
- title: Transaction description
```

#### GroupSettings
```dart
- id: Unique identifier
- groupId: Group identifier (Group1-4)
- groupName: Custom group name
- iconCodePoint: Icon reference
- colorValue: Color value
- savingsGoalEnabled: Savings goal status
- savingsGoalAmount: Target amount
```

#### NoteModel
```dart
- id: Unique identifier
- title: Note title
- content: Note content
- colorValue: Color tag
- date: Creation date
- category: Note category
- isPinned: Pin status
```

---

## 🌍 Localization

The app supports full localization for:
- **Thai (th)**: Complete Thai language support
- **English (en)**: Full English translation
- **Chinese (zh)**: Chinese language support

Currency options:
- **Thai Baht (฿)**: THB currency
- **US Dollar ($)**: USD currency
- **Chinese Yuan (¥)**: CNY currency

---

## 🎨 Theming

### Light Theme
- Background: `#F1F1F1`
- Card Background: `#FFFFFF`
- Accent Color: `#8CDD00`
- Text: `#000000`

### Dark Theme
- Background: `#000000`
- Card Background: `#141414`
- Accent Color: `#ACF532`
- Text: `#FFFFFF`

Theme persistence using SharedPreferences.

---

## 🔐 Privacy & Security

- **Local Storage Only**: All data is stored locally using SQLite
- **No Cloud Sync**: No data is transmitted to external servers
- **No Analytics**: No user tracking or analytics collection
- **Privacy Policy**: Clear and transparent data handling

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Developer

Developed with ❤️ using Flutter and Dart

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📮 Support

For support, please open an issue in the GitHub repository or contact the developer.

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Provider package for state management
- FL Chart for beautiful charting capabilities
- The open-source community

---

<div align="center">

**Made with Flutter**

[⬆ Back to Top](#-bookbank)

</div>
