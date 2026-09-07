import SwiftUI

struct ContentView: View {
    @State private var input = ""
    @State private var convertsCelsiusToFahrenheit = true
    @State private var result: Double?
    @State private var errorMessage = ""
    @State private var showsError = false
    @FocusState private var inputIsFocused: Bool

    private let handoutBlue = Color(
        red: 174 / 255,
        green: 205 / 255,
        blue: 239 / 255
    )

    private var direction: ConversionDirection {
        convertsCelsiusToFahrenheit ? .celsiusToFahrenheit : .fahrenheitToCelsius
    }

    private var outputText: String {
        guard let result else {
            return "Temp \(direction.outputUnit)"
        }

        return "\(TemperatureConverter.formatted(result)) \(direction.outputUnit)"
    }

    var body: some View {
        NavigationView {
            ZStack {
                handoutBlue
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    Text(outputText)
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.48))
                        .contentTransition(.numericText())

                    Spacer()

                    VStack(spacing: 7) {
                        Text("Enter Temperature:")
                            .font(.caption.bold())
                            .foregroundStyle(.black.opacity(0.75))

                        TextField("temperature", text: $input)
                            .keyboardType(.numbersAndPunctuation)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .focused($inputIsFocused)
                            .multilineTextAlignment(.center)
                            .font(.caption)
                            .foregroundStyle(.white)
                            .frame(width: 150, height: 30)
                            .overlay {
                                Rectangle()
                                    .stroke(.white.opacity(0.35), lineWidth: 1)
                            }
                            .onSubmit(convert)
                            .onChange(of: input) {
                                result = nil
                            }
                    }

                    Spacer()
                        .frame(height: 62)

                    HStack(spacing: 13) {
                        Text("°F -> °C")

                        Toggle("Conversion direction", isOn: $convertsCelsiusToFahrenheit)
                            .labelsHidden()
                            .tint(.green)
                            .scaleEffect(0.82)
                            .onChange(of: convertsCelsiusToFahrenheit) {
                                result = nil
                            }

                        Text("°C -> °F")
                    }
                    .font(.caption.bold())
                    .foregroundStyle(.black.opacity(0.78))

                    Button("Convert", action: convert)
                        .font(.caption)
                        .foregroundStyle(.blue.opacity(0.65))
                        .padding(.horizontal, 14)
                        .frame(height: 38)
                        .background(.white, in: RoundedRectangle(cornerRadius: 9))
                        .padding(.top, 17)

                    Spacer()

                    NavigationLink(destination: InfoView()) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 16))
                            .foregroundStyle(.white.opacity(0.7))
                            .padding(12)
                    }
                    .accessibilityLabel("About TempConverter")
                    .padding(.bottom, 22)
                }
                .padding(.top, 42)
            }
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") { inputIsFocused = false }
                }
            }
            .alert("Invalid Temperature", isPresented: $showsError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
        .navigationViewStyle(.stack)
    }

    private func convert() {
        inputIsFocused = false

        do {
            let value = try TemperatureConverter.parse(input)
            withAnimation(.easeInOut(duration: 0.2)) {
                result = direction.convert(value)
            }
        } catch let error as TemperatureInputError {
            result = nil
            errorMessage = error.errorDescription ?? "Enter a valid temperature."
            showsError = true
        } catch {
            result = nil
            errorMessage = "Enter a valid temperature."
            showsError = true
        }
    }
}
