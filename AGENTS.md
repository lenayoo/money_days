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
- English (default)
- Japanese
- Korean

Requirements:
- All user-facing text must be localized.
- Do not hardcode strings directly in UI components.
- Use a centralized localization system (e.g., Flutter intl).

Language behavior:
- Default language follows the device language.
- If the device language is not supported, fall back to English.

Settings screen:
- User must be able to manually select:
  - English
  - 日本語
  - 한국어

## Localization Guidelines

Tone:
- Calm
- Short
- Gentle
- Non-judgmental

Do not use:
- Harsh wording
- Financial pressure tone
- Complex expressions

Example translations:

English:
- Today
- This week
- This month so far
- Monthly budget
- Add today’s spending

Japanese:
- 今日
- 今週
- 今月の合計
- 今月の予算
- 今日の支出を追加

Korean:
- 오늘
- 이번 주
- 이번 달 누적
- 월 예산
- 오늘 지출 추가

Important:
All new features must include translations for all supported languages before completion.

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
- English, Japanese, and Korean localization

The app should be App Store / Google Play ready after basic polish.


## Additional Money Days Features

### Monthly Budget
Money Days should support a monthly budget.

Rules:
- Budget is stored per month.
- A new month can have a new budget.
- Past month budgets should remain unchanged.
- If the current month has no budget, show a calm prompt to set one.

Monthly budget should appear near “This month so far” on the Home screen.

### Review Month Selection
The Review screen should include month selection.

When a month is selected, show:
- Total spending for selected month
- Monthly budget for selected month
- Spending by category
- Expense list for selected month

## Currency Conversion System (UPDATED)

Money Days must use a single base currency for all conversions.

### Base Currency
- USD is used as the internal base currency.

### Fixed Conversion Rates
- USD = 1.0
- JPY = 150
- KRW = 1500
- SGD = 1.35

### Conversion Rule
All currency conversions must follow:

1. Convert from original currency → USD
2. Convert from USD → target currency

### Example
JPY → SGD:
- 1500 JPY → 10 USD
- 10 USD → 13.5 SGD

### Important Rules
- Do NOT convert between non-USD currencies directly
- Avoid double conversion
- Store original values safely
- Apply conversion only at display layer

## App Icon and Logo Generation (MANDATORY)

Money Days must always generate a logo asset from the app icon.

Source:
- assets/imgs/appIcon.png

### Task (must execute)
When building or updating the app, you MUST:

1. Load the image:
   assets/imgs/appIcon.png

2. Generate a logo image that includes:
   - The app icon (centered or top)
   - The text: "Money Days"
   - Optional subtitle: "Daily Budget Tracker"

3. Export logo files to:
   - assets/imgs/logo_1024.png
   - assets/imgs/logo_500.png

### Design Rules
- Keep the exact same visual style as appIcon.png
- Do NOT redesign the character (e.g., piggy bank)
- Do NOT change colors or illustration style
- Use minimal, clean typography
- Keep large spacing and soft layout
- White or very light background preferred

### Layout Example
- Top: icon (appIcon.png)
- Middle: "Money Days"
- Bottom (optional): "Daily Budget Tracker"

### Technical Rules
- Output must be square (1:1)
- Background must not be transparent unless specified
- Ensure text is centered and readable
- Avoid small text (must be visible on mobile)

### Important
This is NOT optional.

The logo MUST be generated automatically using appIcon.png.
Do not skip this step.
Do not leave logo missing.

If logo files do not exist, create them before completing the task.

## Currency Handling Rules

- The app must support only a minimal set of currencies for simplicity and fast UX.
- Default supported currencies are: JPY, USD, KRW.
- Additional currencies should NOT be added unless there is a clear user need.

### Exception
- SGD (Singapore Dollar) is allowed as an additional currency for specific user needs.

### Implementation Rules
- Currency list must be easily extendable (e.g., using a config or enum structure).
- Avoid hardcoding logic tied to specific currencies.
- Keep UI simple and avoid long currency selection lists.

### Principle
Focus on speed and simplicity over completeness.

## Category Trend and Share Features

Money Days should support simple category-based spending review and sharing.

### Share Feature

Money Days should include a simple share feature.

Users should be able to share:
- Monthly summary
- Selected category trend
- Budget progress

Share content should include:
- App name: Money Days
- Selected month
- Total spending
- Budget progress if available
- Category summary if available

Share format:
- Generate a clean image card for sharing.
- The share card should follow Verydays design:
  - soft background
  - centered layout
  - simple typography
  - no unnecessary decoration

Example share text:
- “My Money Days summary”
- “This month so far”
- “Monthly budget progress”
- “A quiet record of my spending.”

Important:
- Do not include private memo details by default.
- Do not expose full expense history in shared content.
- Sharing should feel safe and minimal.

## Major UI Refactor Direction

Money Days should be refactored into a clean monthly calendar-based money tracking app.

The UI reference direction is:
- Full monthly calendar view
- Clear income and expense summary
- Simple monthly budget overview
- Category analysis using a pie chart
- Clean white-based design
- Minimal, modern, non-AI-generated look

The app should feel like a polished personal finance calendar, not a complex accounting dashboard.

---

## Main Screen: Monthly Calendar View

The main screen should center around a full monthly calendar.

Requirements:
- Show the selected month at the top.
- Display a full calendar grid for the month.
- Show daily expense/income indicators inside each date cell.
- Keep the calendar clean and readable.
- Avoid heavy colors and visual clutter.

Top monthly summary should include:
- Monthly income
- Monthly expense
- Monthly budget
- Remaining budget or budget progress

Example layout:

May 2026

Income: ¥120,000  
Budget: ¥80,000  
Expense: ¥53,000  

Remaining: ¥27,000

The monthly budget area should clearly show:
- Income
- Monthly budget
- Monthly spending
- Remaining amount

Use a simple progress bar to show budget usage.

---

## Add Transaction Screen

The add transaction screen should allow users to add both expense and income.

Required fields:
- Type: Expense / Income
- Amount
- Date
- Category
- Payment method optional
- Memo optional

Design rules:
- Keep the screen simple.
- Do not use oversized text.
- Avoid too many colorful icons.
- Category selection should be clean and easy to scan.
- Use simple icons only if they improve usability.

---

## Review / Analysis Screen

The Review screen should focus on simple category analysis.

Use:
- Pie chart for category breakdown
- Monthly total
- Category list with amount and percentage

Do NOT use:
- Radar chart
- Star-shaped chart
- Complex finance dashboard UI
- Heavy graph decorations

Pie chart rules:
- Soft colors only
- Minimal labels
- Show category name, amount, and percentage
- Keep the chart readable and calm

Purpose:
The analysis should help users understand where their money went this month without feeling judged.

---

## Monthly Budget Display

Money Days must support monthly budget tracking.

The monthly budget section must show:
- Monthly income
- Monthly budget
- Monthly expense
- Remaining budget

Budget calculation:
- Remaining budget = Monthly budget - Monthly expense
- Income is shown separately and should not replace budget
- Budget should be stored per month
- Past month budgets should remain unchanged

If no budget is set:
- Show a calm prompt:
  - “Set monthly budget”

Design:
- Use white background
- Use subtle borders or soft cards
- Use a simple progress bar
- Avoid aggressive warning colors

---

## Visual Design Refactor

Refactor the entire app to a clean white-based design.

Use:
- White background
- Dark neutral text
- Light gray secondary text
- Very soft accent colors
- Minimal cards
- Subtle dividers

Avoid:
- Dark theme as default
- Heavy gray/yellow theme
- Oversized typography
- AI-generated looking UI
- Too many decorative icons
- Strong shadows
- Strong gradients

Typography:
- Use smaller, refined font sizes
- Large numbers should be readable but not huge
- Section titles should be calm and minimal
- Keep spacing consistent

The app should feel:
- clean
- calm
- modern
- human-made
- polished
- App Store ready