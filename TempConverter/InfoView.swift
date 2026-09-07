import SwiftUI

struct InfoView: View {
    private let handoutBlue = Color(
        red: 174 / 255,
        green: 205 / 255,
        blue: 239 / 255
    )

    var body: some View {
        ZStack {
            handoutBlue
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("TempConverter")
                    .font(.title2.bold())

                Text("Use the switch to choose a conversion direction, enter a temperature, and tap Convert.")
                    .multilineTextAlignment(.center)

                VStack(spacing: 12) {
                    Text(ConversionDirection.celsiusToFahrenheit.formula)
                    Text(ConversionDirection.fahrenheitToCelsius.formula)
                }
                .font(.subheadline.monospaced())

                Spacer()
            }
            .foregroundStyle(.black.opacity(0.72))
            .padding(.horizontal, 34)
            .padding(.top, 70)
        }
        .navigationTitle("Info")
        .navigationBarTitleDisplayMode(.inline)
    }
}
