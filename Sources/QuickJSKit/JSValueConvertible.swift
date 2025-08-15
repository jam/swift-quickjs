import Foundation

/// Protocol for types that can be converted from a JSValue
public protocol JSValueConvertible {
    static func convert(from value: JSValue) throws -> Self
}

// MARK: - Standard type conformances

extension Double: JSValueConvertible {
    public static func convert(from value: JSValue) throws -> Double {
        return try value.toDouble()
    }
}

extension Int: JSValueConvertible {
    public static func convert(from value: JSValue) throws -> Int {
        return Int(try value.toInt())
    }
}

extension Int32: JSValueConvertible {
    public static func convert(from value: JSValue) throws -> Int32 {
        return try value.toInt()
    }
}

extension String: JSValueConvertible {
    public static func convert(from value: JSValue) throws -> String {
        return try value.toString()
    }
}

extension Bool: JSValueConvertible {
    public static func convert(from value: JSValue) throws -> Bool {
        return value.toBool()
    }
}

extension JSValue: JSValueConvertible {
    public static func convert(from value: JSValue) throws -> JSValue {
        return value
    }
}