import Foundation

enum ConversionDirection: String, CaseIterable, Identifiable {
    case celsiusToFahrenheit
    case fahrenheitToCelsius

    var id: Self { self }

    var title: String {
        switch self {
        case .celsiusToFahrenheit: "Celsius to Fahrenheit"
        case .fahrenheitToCelsius: "Fahrenheit to Celsius"
        }
    }

    var shortLabel: String {
        switch self {
        case .celsiusToFahrenheit: "°C  →  °F"
        case .fahrenheitToCelsius: "°F  →  °C"
        }
    }

    var inputUnit: String {
        switch self {
        case .celsiusToFahrenheit: "°C"
        case .fahrenheitToCelsius: "°F"
        }
    }

    var outputUnit: String {
        switch self {
        case .celsiusToFahrenheit: "°F"
        case .fahrenheitToCelsius: "°C"
        }
    }

    var formula: String {
        switch self {
        case .celsiusToFahrenheit: "°F = (°C × 9/5) + 32"
        case .fahrenheitToCelsius: "°C = (°F − 32) × 5/9"
        }
    }

    func convert(_ value: Double) -> Double {
        switch self {
        case .celsiusToFahrenheit:
            return (value * 9 / 5) + 32
        case .fahrenheitToCelsius:
            return (value - 32) * 5 / 9
        }
    }
}

enum TemperatureInputError: LocalizedError, Equatable {
    case empty
    case invalid

    var errorDescription: String? {
        switch self {
        case .empty: "Enter a temperature first."
        case .invalid: "Enter a valid number, such as 25 or -4.5."
        }
    }
}

enum TemperatureConverter {
    static func parse(_ text: String) throws -> Double {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            throw TemperatureInputError.empty
        }

        // Accept either decimal separator so the field works across locales.
        let normalized = trimmed.replacingOccurrences(of: ",", with: ".")
        guard let value = Double(normalized), value.isFinite else {
            throw TemperatureInputError.invalid
        }

        return value
    }

    static func formatted(_ value: Double) -> String {
        value.formatted(
            .number
                .precision(.fractionLength(0...2))
                .grouping(.never)
        )
    }
}
