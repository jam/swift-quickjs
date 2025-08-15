import CQuickJS

public final class JSValue {
    private let value: CQuickJS.JSValue
    private let context: JSContext
    
    internal init(context: JSContext, value: CQuickJS.JSValue) {
        self.context = context
        self.value = value
    }
    
    deinit {
        JS_FreeValue(context.rawValue, value)
    }
    
    internal var rawValue: CQuickJS.JSValue {
        return value
    }
    
    // MARK: - Type checking
    
    public var isNumber: Bool {
        return JS_IsNumber(value)
    }
    
    public var isString: Bool {
        return JS_IsString(value)
    }
    
    public var isBool: Bool {
        return JS_IsBool(value)
    }
    
    public var isNull: Bool {
        return JS_IsNull(value)
    }
    
    public var isUndefined: Bool {
        return JS_IsUndefined(value)
    }
    
    public var isObject: Bool {
        return JS_IsObject(value)
    }
    
    public var isArray: Bool {
        return JS_IsArray(value)
    }
    
    // MARK: - Value conversion
    
    public func toDouble() throws -> Double {
        var result: Double = 0
        let success = JS_ToFloat64(context.rawValue, &result, value)
        guard success == 0 else {
            let valueType = getValueTypeName()
            throw JSError.conversionFailed(from: valueType, to: "Double")
        }
        return result
    }
    
    public func toInt() throws -> Int32 {
        var result: Int32 = 0
        let success = JS_ToInt32(context.rawValue, &result, value)
        guard success == 0 else {
            let valueType = getValueTypeName()
            throw JSError.conversionFailed(from: valueType, to: "Int32")
        }
        return result
    }
    
    public func toString() throws -> String {
        guard let cString = JS_ToCString(context.rawValue, value) else {
            let valueType = getValueTypeName()
            throw JSError.conversionFailed(from: valueType, to: "String")
        }
        defer { JS_FreeCString(context.rawValue, cString) }
        return String(cString: cString)
    }
    
    private func getValueTypeName() -> String {
        if isNumber { return "Number" }
        if isString { return "String" }
        if isBool { return "Boolean" }
        if isNull { return "null" }
        if isUndefined { return "undefined" }
        if isArray { return "Array" }
        if isObject { return "Object" }
        return "Unknown"
    }
    
    public func toBool() -> Bool {
        return JS_ToBool(context.rawValue, value) != 0
    }
}