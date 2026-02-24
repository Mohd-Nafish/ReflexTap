//
//  ContentView.swift
//  ReflexTap
//
//  Created by Nafish on 24/02/26.
//

import SwiftUI
import Charts
import UIKit

enum GameState {
    case idle
    case waiting
    case ready
    case result
}

enum HapticType {
    case success
    case error
    case medium
}

struct ContentView: View {
    
    @State private var gameState: GameState = .idle
    @State private var startTime: Date?
    @State private var reactionTime: Double = 0
    @State private var bestScore: Double = UserDefaults.standard.double(forKey: "bestScore")
    @State private var showTooSoon: Bool = false
    @State private var reactionHistory: [Double] =
        UserDefaults.standard.array(forKey: "reactionHistory") as? [Double] ?? []
    
    var stateOverlayColor: Color {
        switch gameState {
        case .waiting:
            return Color.red.opacity(0.6)
        case .ready:
            return Color.green.opacity(0.6)
        default:
            return Color.clear
        }
    }
    
    var body: some View {
        ZStack {
            
            // MARK: - Background Gradient
            LinearGradient(
                colors: [
                    Color.black,
                    Color.blue.opacity(0.4),
                    Color.purple.opacity(0.6)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // State Overlay Color
            stateOverlayColor
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.2), value: gameState)
            
            VStack {
                Spacer()
                
                // MARK: - Glass Card
                VStack(spacing: 25) {
                    
                    Text("ReflexTap")
                        .font(.largeTitle.bold())
                        .foregroundColor(.white)
                    
                    if gameState == .idle {
                        Text("Best: \(formattedBestScore()) s")
                            .foregroundColor(.white.opacity(0.8))
                        
                        Button("START") {
                            startGame()
                        }
                        .buttonStyle(MainButtonStyle())
                    }
                    
                    if gameState == .waiting {
                        Text("Wait for Green...")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    if gameState == .ready {
                        Text("TAP!")
                            .font(.system(size: 55, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .white.opacity(0.5), radius: 10)
                    }
                    
                    if gameState == .result {
                        
                        Text("\(formattedReactionTime()) s")
                            .font(.system(size: 60, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .white.opacity(0.5), radius: 10)
                        
                        Text(performanceLabel())
                            .foregroundColor(.white.opacity(0.8))
                        
                        if !reactionHistory.isEmpty {
                            Chart {
                                ForEach(Array(reactionHistory.enumerated()), id: \.offset) { index, value in
                                    LineMark(
                                        x: .value("Attempt", index + 1),
                                        y: .value("Time", value)
                                    )
                                    PointMark(
                                        x: .value("Attempt", index + 1),
                                        y: .value("Time", value)
                                    )
                                }
                            }
                            .frame(height: 200)
                            .padding()
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(20)
                            .chartYScale(domain: 0...1)
                        }
                        
                        Button("Try Again") {
                            resetGame()
                        }
                        .buttonStyle(MainButtonStyle())
                    }
                    
                    if showTooSoon {
                        Text("Too Soon!")
                            .foregroundColor(.yellow)
                            .font(.headline)
                    }
                }
                .padding(30)
                .background(.ultraThinMaterial)
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
                
                Spacer()
            }
            .padding()
        }
        .onTapGesture {
            handleTap()
        }
    }
    
    // MARK: - Game Logic
    
    func startGame() {
        showTooSoon = false
        gameState = .waiting
        
        let randomDelay = Double.random(in: 1.5...4.0)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
            guard gameState == .waiting else { return }
            
            // Start timing EXACT moment green appears
            startTime = Date()
            gameState = .ready
            triggerHaptic(.medium)
        }
    }
    
    func handleTap() {
        switch gameState {
            
        case .waiting:
            showTooSoon = true
            triggerHaptic(.error)
            resetGame()
            
        case .ready:
            guard let start = startTime else { return }
            
            reactionTime = Date().timeIntervalSince(start)
            updateBestScore()
            addToHistory(reactionTime)
            gameState = .result
            triggerHaptic(.success)
            
        default:
            break
        }
    }
    
    func resetGame() {
        gameState = .idle
    }
    
    func updateBestScore() {
        if bestScore == 0 || reactionTime < bestScore {
            bestScore = reactionTime
            UserDefaults.standard.set(bestScore, forKey: "bestScore")
        }
    }
    
    func addToHistory(_ time: Double) {
        reactionHistory.append(time)
        
        if reactionHistory.count > 10 {
            reactionHistory.removeFirst()
        }
        
        UserDefaults.standard.set(reactionHistory, forKey: "reactionHistory")
    }
    
    // MARK: - Formatting
    
    func formattedReactionTime() -> String {
        String(format: "%.3f", reactionTime)
    }
    
    func formattedBestScore() -> String {
        bestScore == 0 ? "--" : String(format: "%.3f", bestScore)
    }
    
    func performanceLabel() -> String {
        switch reactionTime {
        case ..<0.200:
            return "Elite Reflexes"
        case 0.200..<0.250:
            return "Fast"
        case 0.250..<0.300:
            return "Average"
        default:
            return "Needs Practice"
        }
    }
    
    // MARK: - Haptics
    
    func triggerHaptic(_ type: HapticType) {
        switch type {
        case .success:
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .error:
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .medium:
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
    }
}

// MARK: - Button Style

struct MainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline.bold())
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    colors: [Color.white, Color.gray.opacity(0.8)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .foregroundColor(.black)
            .cornerRadius(20)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}
