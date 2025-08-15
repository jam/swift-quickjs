import Foundation

public enum JSError: Error, LocalizedError {
    case runtimeCreationFailed
    case contextCreationFailed
    case evaluationFailed(message: String?, filename: String?, line: Int?)
    case conversionFailed(from: String, to: String)
    case invalidValue(description: String)
    
    public var errorDescription: String? {
        switch self {
        case .runtimeCreationFailed:
            return "Failed to create JavaScript runtime"
        case .contextCreationFailed:
            return "Failed to create JavaScript context"
        case .evaluationFailed(let message, let filename, let line):
            var desc = "JavaScript evaluation failed"
            if let filename = filename {
                desc += " in \(filename)"
                if let line = line {
                    desc += ":\(line)"
                }
            }
            if let message = message {
                desc += " - \(message)"
            }
            return desc
        case .conversionFailed(let from, let to):
            return "Failed to convert JavaScript value from \(from) to \(to)"
        case .invalidValue(let description):
            return "Invalid JavaScript value: \(description)"
        }
    }
}