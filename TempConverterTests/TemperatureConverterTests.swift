import XCTest
@testable import TempConverter

final class TemperatureConverterTests: XCTestCase {
    func testCelsiusToFahrenheit() {
        XCTAssertEqual(ConversionDirection.celsiusToFahrenheit.convert(0), 32, accuracy: 0.001)
        XCTAssertEqual(ConversionDirection.celsiusToFahrenheit.convert(100), 212, accuracy: 0.001)
    }

    func testFahrenheitToCelsius() {
        XCTAssertEqual(ConversionDirection.fahrenheitToCelsius.convert(32), 0, accuracy: 0.001)
        XCTAssertEqual(ConversionDirection.fahrenheitToCelsius.convert(212), 100, accuracy: 0.001)
    }

    func testNegativeAndDecimalInput() throws {
        XCTAssertEqual(try TemperatureConverter.parse(" -4.5 "), -4.5, accuracy: 0.001)
        XCTAssertEqual(try TemperatureConverter.parse("12,5"), 12.5, accuracy: 0.001)
    }

    func testEmptyInputIsRejected() {
        XCTAssertThrowsError(try TemperatureConverter.parse("   ")) { error in
            XCTAssertEqual(error as? TemperatureInputError, .empty)
        }
    }

    func testNonnumericInputIsRejected() {
        XCTAssertThrowsError(try TemperatureConverter.parse("warm")) { error in
            XCTAssertEqual(error as? TemperatureInputError, .invalid)
        }
    }
}
