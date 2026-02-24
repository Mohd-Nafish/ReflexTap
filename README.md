# 📱 ReflexTap

A minimal, modern reaction speed test app built using **SwiftUI**.

ReflexTap measures how quickly a user responds when the screen turns green. The app focuses on clean UI, smooth state transitions, and precise timing logic.

---

## 🚀 Features

- ⏱ Accurate reaction timing (seconds with decimal precision)
- 🎯 Random delay logic to prevent anticipation
- 📊 Reaction history graph (last 10 attempts)
- 🏆 Best score tracking
- 📳 Haptic feedback integration
- 🎨 Modern gradient + glass-style UI
- 💾 Local data persistence using UserDefaults

---

## 🛠 Built With

- Swift  
- SwiftUI  
- Swift Charts  
- UIKit (for haptics)  
- UserDefaults (local storage)  

---

## 📸 Screenshots

<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-24 at 17 14 33" src="https://github.com/user-attachments/assets/5208d9c0-d77e-467e-8965-ac1c9c31b3c0" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-24 at 17 14 45" src="https://github.com/user-attachments/assets/7aada194-ad2e-4f44-963c-ca92b0fdedda" />




## 🧠 How It Works

1. User taps **Start**
2. Screen turns **Red** (“Wait…”)
3. After a random delay, screen turns **Green**
4. User taps immediately
5. Reaction time is calculated using:

```swift
Date().timeIntervalSince(startTime)
```

6. Score is saved locally  
7. Graph updates with the latest attempt  

## 📈 Performance Ranking Logic

| Reaction Time | Ranking |
|---------------|----------|
| < 0.200 s     | Elite Reflexes |
| 0.200 – 0.250 s | Fast |
| 0.250 – 0.300 s | Average |
| > 0.300 s     | Needs Practice |

---

## 🏗 Project Structure

```
ReflexTap/
│
├── ContentView.swift
├── GameState.swift
├── Components/
│   └── CustomButtonStyle.swift
├── Charts/
│   └── ReactionChartView.swift
└── Persistence/
    └── UserDefaultsManager.swift
```

---

## 📦 Requirements

- iOS 16+
- Xcode 15+

---

## 🎯 Purpose

This project was built to:

- Practice SwiftUI state-driven architecture  
- Implement accurate timing logic  
- Integrate haptic feedback  
- Use Swift Charts for data visualization  
- Improve UI polish and app structure  

---

## 👨‍💻 Author

Mohd Nafishuddin  
B.Tech Computer Science  
iOS Development Enthusiast  
