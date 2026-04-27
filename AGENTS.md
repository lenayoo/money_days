# AGENTS.md — Money Days

## Product
Money Days is a simple personal money tracking app by Verydays.

It helps users record daily spending, notice small money habits, and review their month calmly.
The app should feel quiet, clean, and lightweight — not like a complex finance dashboard.

Brand direction:
- Calm
- Simple
- Everyday
- Minimal
- Trustworthy
- Soft but not childish

Reference brand tone:
Verydays: “Quiet apps for everyday life”
Small apps for reflection, emotional check-ins, and everyday habits.

## Tech Stack
- Flutter
- Dart
- Local-first data storage
- No account required for MVP
- No ads
- No unnecessary tracking

## Languages
The app must support:
- English
- Korean
- Japanese

Structure the app so Korean can be added later, but do not implement Korean in the first version unless requested.

Use Flutter localization-friendly structure.
All user-facing strings must be separated from UI code.

## Design
Use a clean Verydays-like design.

Visual style:
- White or warm off-white background
- Soft neutral text colors
- Simple rounded cards
- Generous spacing
- Minimal icons
- No heavy gradients
- No loud colors
- No complex charts in MVP
- App should feel calm and premium

Typography:
- Use clean system fonts by default
- Avoid playful or decorative fonts
- Text hierarchy should be clear:
  - Large calm title
  - Small supportive subtitle
  - Simple body text

Tone of text:
- Gentle
- Short
- Non-judgmental
- No guilt-based money language

Examples:
- “Add today’s spending”
- “A small record for today.”
- “This month so far”
- “You spent most on food this month.”
- “Review your money days calmly.”

## MVP Features

### 1. Home Screen
Show:
- App title: Money Days
- Today’s total spending
- This month’s total spending
- Button to add expense
- Recent expense list

The home screen should be simple and useful immediately.

### 2. Add Expense Screen
Fields:
- Amount
- Category
- Memo optional
- Date

Categories:
- Food
- Cafe
- Transport
- Shopping
- Health
- Home
- Subscription
- Other

User should be able to save quickly.

### 3. Monthly Review Screen
Show:
- Total monthly spending
- Spending by category
- Simple list or soft progress bars
- No complex analytics yet

### 4. Settings Screen
Show:
- Language setting
- Currency setting
- App information
- Privacy note

Supported initial currencies:
- JPY
- USD
- KRW

Default currency: JPY

## Data Model

Expense:
- id
- amount
- category
- memo
- date
- currency
- createdAt
- updatedAt

Category:
- id
- name
- icon optional
- color optional

## Architecture
Use a simple but scalable structure.

Recommended folders:

lib/
- main.dart
- app/
- core/
  - constants/
  - theme/
  - localization/
  - utils/
- features/
  - expenses/
    - models/
    - repositories/
    - screens/
    - widgets/
  - review/
    - screens/
    - widgets/
  - settings/
    - screens/
    - widgets/

Keep files small.
Separate UI, models, and data logic.
Avoid putting all logic inside screen widgets.

## State Management
Use a simple state management approach suitable for MVP.
Prefer:
- Riverpod
or
- Provider

Do not over-engineer.

## Storage
Use local storage for MVP.
Prefer:
- Hive
or
- shared_preferences only if the data is very simple

Expense records should persist after app restart.

## Monetization Preparation
Do not implement payment in the first step unless explicitly requested.

However, structure the app so that a future premium plan can be added.

Future premium ideas:
- Monthly budget
- Category budget
- Export CSV
- More themes
- Advanced monthly insights
- Cloud backup

## Privacy
Money Days should be privacy-friendly.

For MVP:
- No login
- No cloud sync
- No third-party analytics unless requested
- User data stays on device

Include a simple privacy message in Settings:
“Your records are stored on this device.”

## Coding Rules
- Write readable Flutter code
- Use meaningful names
- Prefer small reusable widgets
- Avoid unnecessary packages
- Do not introduce backend services
- Do not add authentication
- Do not add ads
- Do not add complex animations
- Keep MVP shippable

## First Build Goal
Create a working MVP with:
- Home screen
- Add expense screen
- Monthly review screen
- Settings screen
- English and Japanese localization
- Local expense storage
- Clean Verydays-style theme

The app should be App Store / Google Play ready after basic polish.