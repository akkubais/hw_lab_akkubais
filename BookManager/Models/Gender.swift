import Foundation

enum Gender: String, CaseIterable, Identifiable {
    case female = "Female"
    case male = "Male"

    var id: String { rawValue }
}
