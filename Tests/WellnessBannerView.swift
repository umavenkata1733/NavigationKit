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






////////







Here’s a **beautified, MVP-style Confluence document** for your SwiftUI SPM reusable components. This version uses formatting, emojis, clear sections, and better visual hierarchy to make it feel more polished and ready for teams or stakeholders reviewing your work.

---

# 🚀 SwiftUI Component Library – MVP Documentation

> **📦 Module:** `YourPackageName`  
> **🎯 Purpose:** Centralized library of SwiftUI reusable components for consistency, reusability, and faster development across iOS projects.

---

## 🧭 Overview

This package contains a collection of reusable SwiftUI views and modifiers designed to simplify UI development and promote design consistency. Each component is documented below with:

- 📌 Purpose
- 🧩 Parameters
- 💻 Usage Example
- 🛠️ Customization Notes
- 📁 File Location (SPM structure)

---

## 🔧 Component Details

---

### ❗️**ErrorView**

| Property       | Description                            |
|----------------|----------------------------------------|
| **Purpose**    | Displays an error message with optional retry button |
| **Parameters** | `message: String`<br>`onRetry: (() -> Void)?` |
| **Location**   | `Sources/YourPackage/Components/ErrorView.swift` |

**💡 Usage**
```swift
ErrorView(message: "Something went wrong", onRetry: { retryLogic() })
```

---

### 💬 **FeatureInfoView**

| Property       | Description                                  |
|----------------|----------------------------------------------|
| **Purpose**    | Show feature descriptions with title + icon  |
| **Parameters** | `title: String`<br>`description: String`<br>`icon: Image` |
| **Location**   | `Sources/YourPackage/Components/FeatureInfoView.swift` |

**💡 Usage**
```swift
FeatureInfoView(
  title: "24/7 Support",
  description: "We’re always here to help.",
  icon: Image(systemName: "headphones")
)
```

---

### 🧘‍♀️ **MentalWellnessView**

| Property       | Description                                   |
|----------------|-----------------------------------------------|
| **Purpose**    | Displays mental wellness tips in a card format |
| **Parameters** | `title: String`<br>`subtitle: String`<br>`backgroundImage: Image` |
| **Location**   | `Sources/YourPackage/Components/MentalWellnessView.swift` |

**💡 Usage**
```swift
MentalWellnessView(
  title: "Meditation",
  subtitle: "Calm your mind",
  backgroundImage: Image("meditation-bg")
)
```

---

### ⭐️ **CommonlyUsedView**

| Property       | Description                                        |
|----------------|----------------------------------------------------|
| **Purpose**    | Display list of commonly accessed actions/features |
| **Parameters** | `items: [CommonItem]`                              |
| **Location**   | `Sources/YourPackage/Components/CommonlyUsedView.swift` |

**💡 Usage**
```swift
CommonlyUsedView(items: frequentlyUsedList)
```

---

### 🖼️ **CardIconImageView**

| Property       | Description                                 |
|----------------|---------------------------------------------|
| **Purpose**    | Display an icon inside a rounded card style |
| **Parameters** | `image: Image`<br>`backgroundColor: Color`  |
| **Location**   | `Sources/YourPackage/Components/CardIconImageView.swift` |

**💡 Usage**
```swift
CardIconImageView(image: Image(systemName: "heart.fill"), backgroundColor: .pink)
```

---

### 🧾 **BenefitsSummaryView**

| Property       | Description                                 |
|----------------|---------------------------------------------|
| **Purpose**    | Display user benefits in card layout        |
| **Parameters** | `benefits: [BenefitItem]`                   |
| **Location**   | `Sources/YourPackage/Components/BenefitsSummaryView.swift` |

**💡 Usage**
```swift
BenefitsSummaryView(benefits: myPlanBenefits)
```

---

### 🏥 **MedicalPlanView**

| Property       | Description                                      |
|----------------|--------------------------------------------------|
| **Purpose**    | Show medical plan details with collapsible view |
| **Parameters** | `plan: MedicalPlan`                              |
| **Location**   | `Sources/YourPackage/Components/MedicalPlanView.swift` |

**💡 Usage**
```swift
MedicalPlanView(plan: userMedicalPlan)
```

---

### 📐 **EdgePadding Modifier**

| Property       | Description                                   |
|----------------|-----------------------------------------------|
| **Purpose**    | Apply consistent spacing around elements      |
| **Parameters** | None (predefined padding values)              |
| **Location**   | `Sources/YourPackage/Modifiers/EdgePadding.swift` |

**💡 Usage**
```swift
Text("Hello World")
  .modifier(EdgePadding())
```

---

### 🗒️ **CardTextView**

| Property       | Description                                    |
|----------------|------------------------------------------------|
| **Purpose**    | Show important text in a stylized card         |
| **Parameters** | `text: String`<br>`backgroundColor: Color`     |
| **Location**   | `Sources/YourPackage/Components/CardTextView.swift` |

**💡 Usage**
```swift
CardTextView(text: "Important Update", backgroundColor: .yellow)
```

---

### 🔵 **CircularProgressView**

| Property       | Description                            |
|----------------|----------------------------------------|
| **Purpose**    | Displays progress inside a circle      |
| **Parameters** | `progress: Double` (0.0 to 1.0)<br>`label: String` |
| **Location**   | `Sources/YourPackage/Components/CircularProgressView.swift` |

**💡 Usage**
```swift
CircularProgressView(progress: 0.75, label: "75%")
```

---

## 🧱 Future Improvements

- Add live previews for all components
- Support dark mode and accessibility scaling
- Centralize theme colors and fonts

---

Would you like a **Markdown or HTML export** of this for version-controlled README files or docs websites?





/////////



Perfect — you're aiming for **modular documentation** where not only each component is documented, but also **linked to the other reusable components it depends on** (like `CardTextView`, `CardIconImageView`, `EdgePadding`, etc.).

Below is a **Confluence-ready, cleanly structured MVP document** that:
- Documents each component
- Highlights *which subcomponents it depends on* (like building blocks)
- Mentions **`FeatureCardView`** as a reusable component as well
- Makes reuse and modularity easy to understand for the team

---

# 🧱 SwiftUI Reusable Component Library (SPM)

> **📦 Module Name:** `YourPackageName`  
> **🎯 Purpose:** Maintainable, consistent, and modular UI system built with SwiftUI and distributed via Swift Package Manager (SPM).

---

## 📚 Component Structure Overview

Each SwiftUI component is:
- **Modular:** Uses common building blocks (e.g. `CardTextView`, `EdgePadding`, etc.)
- **Composable:** Easily reused across different flows
- **Lightweight:** Focused on design & layout only, logic lives elsewhere

---

## ✅ Core Building Blocks (Used by Multiple Components)

| Component         | Purpose |
|------------------|---------|
| `CardTextView`   | Displays styled text inside a rounded card |
| `CardIconImageView` | Shows icon inside a stylized card container |
| `EdgePadding`    | Applies standardized horizontal/vertical padding |
| `FeatureCardView`| Common card wrapper used for content/tiles |

---

## 🧩 Main Reusable Components

---

### ❗️ ErrorView

| Detail        | Description |
|---------------|-------------|
| **Purpose**   | Show error message with optional Retry button |
| **Depends On**| `CardTextView`, `EdgePadding` |
| **File**      | `ErrorView.swift` |

**💡 Usage:**
```swift
ErrorView(message: "Something went wrong", onRetry: { retryAction() })
```

---

### 💬 FeatureInfoView

| Detail        | Description |
|---------------|-------------|
| **Purpose**   | Showcase a feature with icon, title & description |
| **Depends On**| `CardIconImageView`, `EdgePadding`, `CardTextView`, `FeatureCardView` |
| **File**      | `FeatureInfoView.swift` |

**💡 Usage:**
```swift
FeatureInfoView(
  title: "24/7 Support",
  description: "We're always here to help.",
  icon: Image(systemName: "headphones")
)
```

---

### 🧘 MentalWellnessView

| Detail        | Description |
|---------------|-------------|
| **Purpose**   | Display wellness activities with background image |
| **Depends On**| `FeatureCardView`, `CardTextView`, `EdgePadding` |
| **File**      | `MentalWellnessView.swift` |

**💡 Usage:**
```swift
MentalWellnessView(
  title: "Meditation",
  subtitle: "Calm your mind",
  backgroundImage: Image("bg_meditation")
)
```

---

### ⭐️ CommonlyUsedView

| Detail        | Description |
|---------------|-------------|
| **Purpose**   | Display commonly accessed features (icons + labels) |
| **Depends On**| `CardIconImageView`, `EdgePadding` |
| **File**      | `CommonlyUsedView.swift` |

**💡 Usage:**
```swift
CommonlyUsedView(items: frequentItems)
```

---

### 🧾 BenefitsSummaryView

| Detail        | Description |
|---------------|-------------|
| **Purpose**   | Summarizes user benefits in list form |
| **Depends On**| `CardTextView`, `EdgePadding` |
| **File**      | `BenefitsSummaryView.swift` |

**💡 Usage:**
```swift
BenefitsSummaryView(benefits: benefitsList)
```

---

### 🏥 MedicalPlanView

| Detail        | Description |
|---------------|-------------|
| **Purpose**   | Displays detailed medical plan info |
| **Depends On**| `CardTextView`, `EdgePadding` |
| **File**      | `MedicalPlanView.swift` |

**💡 Usage:**
```swift
MedicalPlanView(plan: planData)
```

---

### 🔁 CircularProgressView

| Detail        | Description |
|---------------|-------------|
| **Purpose**   | Display circular progress ring with label |
| **Depends On**| `EdgePadding` |
| **File**      | `CircularProgressView.swift` |

**💡 Usage:**
```swift
CircularProgressView(progress: 0.8, label: "80%")
```

---

## 🧱 Shared UI Components (Core Reusables)

---

### 🪧 CardTextView

| Property | Description |
|----------|-------------|
| **Purpose** | Shows text inside a rounded card |
| **File**    | `CardTextView.swift` |
| **Used In** | `ErrorView`, `FeatureInfoView`, `BenefitsSummaryView`, `MedicalPlanView`, `MentalWellnessView` |

**💡 Usage**
```swift
CardTextView(text: "Important Update", backgroundColor: .yellow)
```

---

### 🎨 CardIconImageView

| Property | Description |
|----------|-------------|
| **Purpose** | Displays an icon in a circular card container |
| **File**    | `CardIconImageView.swift` |
| **Used In** | `CommonlyUsedView`, `FeatureInfoView` |

**💡 Usage**
```swift
CardIconImageView(image: Image(systemName: "heart.fill"), backgroundColor: .blue)
```

---

### 📐 EdgePadding

| Property | Description |
|----------|-------------|
| **Purpose** | Standardizes padding across all views |
| **File**    | `EdgePadding.swift` |
| **Used In** | Almost all components |

**💡 Usage**
```swift
Text("Hello").modifier(EdgePadding())
```

---

### 🪪 FeatureCardView

| Property | Description |
|----------|-------------|
| **Purpose** | Reusable card wrapper with consistent styling and layout |
| **File**    | `FeatureCardView.swift` |
| **Used In** | `FeatureInfoView`, `MentalWellnessView`, potentially more |

**💡 Usage**
```swift
FeatureCardView {
  VStack {
    Text("Sleep Tracker")
    Text("Track your sleep patterns")
  }
}
```

---

## 📌 Best Practices

- ✅ Always wrap content in `FeatureCardView` or `CardTextView` if a card-like layout is required.
- 🧱 Use `EdgePadding` instead of hardcoded `.padding()`.
- ♻️ Reuse `CardIconImageView` for uniform icon display.
- 🧩 Keep reusable components generic and style-agnostic.

---

Would you like me to generate this as a downloadable file (Markdown/HTML/Confluence XML)? I can also help you link this into your Confluence page hierarchy (like parent-child pages).

*/
