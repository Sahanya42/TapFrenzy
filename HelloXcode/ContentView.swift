
import SwiftUI
public import Combine

struct ContentView: View {

    // Game Variables

    enum GamePhase {
        case idle
        case playing
        case over
    }

    @State private var score = 0
    @State private var timeRemaining = 10
    @State private var phase: GamePhase = .idle

    @State private var buttonSize: CGFloat = 200
    @State private var buttonX: CGFloat = 0
    @State private var buttonY: CGFloat = 0

    @AppStorage("highScore") private var highScore = 0

    // Timers

    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()

    let moveTimer = Timer.publish(
        every: 2,
        on: .main,
        in: .common
    ).autoconnect()

    // Game Screen

    var body: some View {

        VStack(spacing: 25) {

            // Game Title

            Text("Tap Frenzy")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.white)

            // Score

            Text("SCORE")
                .foregroundStyle(.gray)

            Text("\(score)")
                .font(.system(size: 80, weight: .heavy))
                .foregroundStyle(.green)

            // Timer Bar

            ProgressView(
                value: Double(timeRemaining),
                total: 10
            )
            .tint(.green)
            .padding(.horizontal)

            Text("Time: \(timeRemaining)")
                .font(.title2)
                .foregroundStyle(.white)

            // Game Button

            if phase == .over {

                Text("Time's up!")
                    .font(.title)
                    .bold()
                    .foregroundStyle(.white)

                Text("Your Score: \(score)")
                    .foregroundStyle(.white)

                Text("Best: \(highScore)")
                    .foregroundStyle(.green)

                Button("Try Again") {
                    resetGame()
                }
                .font(.title2)
                .foregroundStyle(.black)
                .padding()
                .background(.green)
                .clipShape(Capsule())

            } else {

                Text(phase == .idle ? "tap to start" : "keep tapping!")
                    .foregroundStyle(.gray)

                Button {

                    if phase == .idle {
                        phase = .playing
                    }

                    if phase == .playing {

                        score += 1

                        // Challenge 1: Shrinking Button

                        buttonSize = max(
                            120,
                            buttonSize - 5
                        )
                    }

                } label: {

                    Text("TAP")
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundStyle(.black)
                        .frame(
                            width: buttonSize,
                            height: buttonSize
                        )
                        .background(.green)
                        .clipShape(Circle())
                }
                .offset(x: buttonX, y: buttonY)
                .animation(.easeInOut(duration: 0.2), value: buttonSize)
                .animation(.easeInOut(duration: 0.3), value: buttonX)
                .animation(.easeInOut(duration: 0.3), value: buttonY)

                .frame(height: 230)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)

        // Countdown Timer

        .onReceive(timer) { _ in

            if phase == .playing {

                if timeRemaining > 0 {
                    timeRemaining -= 1
                }

                if timeRemaining == 0 {

                    phase = .over

                    if score > highScore {
                        highScore = score
                    }
                }
            }
        }

        // Moving Button

        .onReceive(moveTimer) { _ in

            if phase == .playing {

                buttonX = CGFloat.random(in: -60...60)
                buttonY = CGFloat.random(in: -30...30)
            }
        }
    }

    //Reset Game

    func resetGame() {

        score = 0
        timeRemaining = 10
        buttonSize = 200

        buttonX = 0
        buttonY = 0

        phase = .idle
    }
}

#Preview {
    ContentView()
}

