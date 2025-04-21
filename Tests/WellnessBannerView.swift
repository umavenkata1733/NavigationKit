/*


# 📦 SwiftUI SPM – Reusable Components

This Swift Package contains reusable SwiftUI components used across multiple modules in the app to promote consistency, reduce redundancy, and improve maintainability. Each component is documented below with its purpose, parameters, usage, and customization options.

---

## 📘 Component Documentation Structure

| Section | Description |
|--------|-------------|
| **Component Name** | The name of the SwiftUI View |
| **Purpose** | What this component is used for |
| **Location** | File location inside the SPM structure |
| **Parameters** | Inputs with descriptions |
| **Example Usage** | Swift code snippet for implementation |
| **Customization** | Styling, theming, or layout notes |
| **Preview (Optional)** | Visual or Canvas preview screenshot |

---

## 🔹 ErrorView

**Purpose:**
Display a consistent error message with an optional retry button.

**Location:**
`Sources/YourPackage/Components/ErrorView.swift`

**Parameters:**
- `message: String` – Error message displayed to the user.
- `onRetry: (() -> Void)?` – Closure executed when "Retry" is tapped.

**Example Usage:**
```swift
ErrorView(message: "Something went wrong", onRetry: { retryLogic() })
```

---

## 🔹 FeatureInfoView

**Purpose:**
Showcase feature highlights, commonly used in onboarding/help sections.

**Location:**
`Sources/YourPackage/Components/FeatureInfoView.swift`

**Parameters:**
- `title: String`
- `description: String`
- `icon: Image`

**Example Usage:**
```swift
FeatureInfoView(title: "24/7 Support", description: "We’re always here to help.", icon: Image(systemName: "headphones"))
```

---

## 🔹 MentalWellnessView

**Purpose:**
Display mental wellness tips with engaging visuals.

**Location:**
`Sources/YourPackage/Components/MentalWellnessView.swift`

**Parameters:**
- `title: String`
- `subtitle: String`
- `backgroundImage: Image`

**Example Usage:**
```swift
MentalWellnessView(title: "Meditation", subtitle: "Calm your mind", backgroundImage: Image("meditation-bg"))
```

---

## 🔹 CommonlyUsedView

**Purpose:**
List most-used features/actions with icons and titles.

**Location:**
`Sources/YourPackage/Components/CommonlyUsedView.swift`

**Parameters:**
- `items: [CommonItem]` – A model with icon, title, and action.

**Example Usage:**
```swift
CommonlyUsedView(items: frequentlyUsedList)
```

---

## 🔹 CardIconImageView

**Purpose:**
Show an icon inside a stylized card background.

**Location:**
`Sources/YourPackage/Components/CardIconImageView.swift`

**Parameters:**
- `image: Image`
- `backgroundColor: Color`

**Example Usage:**
```swift
CardIconImageView(image: Image(systemName: "heart.fill"), backgroundColor: .pink)
```

---

## 🔹 BenefitsSummaryView

**Purpose:**
Display summarized benefits of a user’s plan in card format.

**Location:**
`Sources/YourPackage/Components/BenefitsSummaryView.swift`

**Parameters:**
- `benefits: [BenefitItem]`

**Example Usage:**
```swift
BenefitsSummaryView(benefits: myPlanBenefits)
```

---

## 🔹 MedicalPlanView

**Purpose:**
Display detailed user medical plan info with optional expand/collapse.

**Location:**
`Sources/YourPackage/Components/MedicalPlanView.swift`

**Parameters:**
- `plan: MedicalPlan`

**Example Usage:**
```swift
MedicalPlanView(plan: userMedicalPlan)
```

---

## 🔹 EdgePadding

**Purpose:**
Apply consistent padding via a reusable `ViewModifier`.

**Location:**
`Sources/YourPackage/Modifiers/EdgePadding.swift`

**Parameters:**
None – default internal padding.

**Example Usage:**
```swift
Text("Hello").modifier(EdgePadding())
```

---

## 🔹 CardTextView

**Purpose:**
Show styled text inside a card layout for emphasis or info.

**Location:**
`Sources/YourPackage/Components/CardTextView.swift`

**Parameters:**
- `text: String`
- `backgroundColor: Color`

**Example Usage:**
```swift
CardTextView(text: "Important Update", backgroundColor: .yellow)
```

---

## 🔹 CircularProgressView

**Purpose:**
Displays circular progress with label and percentage.

**Location:**
`Sources/YourPackage/Components/CircularProgressView.swift`

**Parameters:**
- `progress: Double` – From 0.0 to 1.0
- `label: String`

**Example Usage:**
```swift
CircularProgressView(progress: 0.75, label: "75%")
```


*/
