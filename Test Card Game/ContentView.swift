import SwiftUI

//Test

struct ContentView: View {
    // Card values map directly to asset names: card2 ... card14
    @State private var playerCardValue: Int = 2
    @State private var cpuCardValue: Int = 2
    @State private var playerScore: Int = 0
    @State private var cpuScore: Int = 0

    // If you have a card back image in assets, set its name here; otherwise we'll start with a random face.
    private let cardBackName: String? = "cardBack" // set to nil if you don't have a back image

    var body: some View {
        ZStack {
            // Background image if available; otherwise a fallback color
            Group {
                if UIImage(named: "background") != nil {
                    Image("background")
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                } else {
                    Color.brown.opacity(0.85).ignoresSafeArea()
                }
            }

            VStack(spacing: 24) {
                // Logo if available
                if UIImage(named: "logo") != nil {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 90)
                        .padding(.top, 24)
                } else {
                    Text("WAR")
                        .font(.system(size: 48, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                        .padding(.top, 24)
                }

                Spacer()

                HStack(spacing: 28) {
                    cardImage(for: playerCardValue)
                    cardImage(for: cpuCardValue)
                }

                dealButton

                scoreRow

                resetButton

                Spacer(minLength: 16)
            }
            .padding(.horizontal, 24)
        }
    }

    // MARK: - Subviews
    private func cardImage(for value: Int) -> some View {
        Group {
            // Prefer face image; fall back to back if provided; otherwise a rounded rectangle
            if let image = UIImage(named: "card\(value)") {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .shadow(radius: 6)
            } else if let back = cardBackName, UIImage(named: back) != nil {
                Image(back)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)
                    .shadow(radius: 6)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                    .frame(width: 120, height: 180)
                    .overlay(Text("card\(value)").foregroundStyle(.black))
                    .shadow(radius: 6)
            }
        }
    }

    private var dealButton: some View {
        Button(action: dealCards) {
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(LinearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 64)
                Text("DEAL")
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundStyle(.white)
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Deal cards")
        .padding(.top, 8)
    }

    private var resetButton: some View {
        Button("Reset") {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                playerScore = 0
                cpuScore = 0
                // Optionally flip back to starting state
                playerCardValue = 2
                cpuCardValue = 2
            }
        }
        .font(.system(size: 16, weight: .semibold))
        .tint(.blue)
        .padding(.top, 8)
        .accessibilityLabel("Reset scores")
    }

    private var scoreRow: some View {
        HStack {
            VStack(spacing: 4) {
                Text("Player").font(.headline).foregroundStyle(.white)
                Text("\(playerScore)").font(.system(size: 36, weight: .bold, design: .rounded)).foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)

            VStack(spacing: 4) {
                Text("CPU").font(.headline).foregroundStyle(.white)
                Text("\(cpuScore)").font(.system(size: 36, weight: .bold, design: .rounded)).foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.top, 8)
    }

    // MARK: - Logic
    private func dealCards() {
        let newPlayer = Int.random(in: 2...14)
        let newCPU = Int.random(in: 2...14)

        withAnimation(.easeInOut(duration: 0.2)) {
            playerCardValue = newPlayer
            cpuCardValue = newCPU
        }

        if newPlayer > newCPU {
            playerScore += 1
        } else if newCPU > newPlayer {
            cpuScore += 1
        } // ties give no points
    }
}

#Preview {
    ContentView()
}
