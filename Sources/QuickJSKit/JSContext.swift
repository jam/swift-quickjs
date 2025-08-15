import CQuickJS

public final class JSContext {
    private let context: OpaquePointer
    private let runtime: JSRuntime
    
    public init(runtime: JSRuntime) throws {
        guard let context = JS_NewContext(runtime.rawValue) else {
            throw JSError.contextCreationFailed
        }
        self.context = context
        self.runtime = runtime
    }
    
    deinit {
        JS_FreeContext(context)
    }
    
    internal var rawValue: OpaquePointer {
        return context
    }
    
    public func evaluate(_ code: String, filename: String = "<eval>") throws -> JSValue {
        let result = JS_Eval(context, code, code.utf8.count, filename, 0)
        
        if JS_IsException(result) {
            let exception = JS_GetException(context)
            defer { JS_FreeValue(context, exception) }
            
            // Try to extract error message
            var errorMessage: String? = nil
            if let cString = JS_ToCString(context, exception) {
                errorMessage = String(cString: cString)
                JS_FreeCString(context, cString)
            }
            
            throw JSError.evaluationFailed(message: errorMessage, filename: filename, line: nil)
        }
        
        return JSValue(context: self, value: result)
    }
    
    // MARK: - Type-inferred evaluation
    
    /// Evaluates JavaScript code and converts the result to the specified type
    /// Usage: let result: Int = try context.evaluate("2 + 3")
    public func evaluate<T: JSValueConvertible>(_ code: String, filename: String = "<eval>") throws -> T {
        let jsValue = try evaluate(code, filename: filename)
        return try T.convert(from: jsValue)
    }
    
    // MARK: - Convenience methods
    
    public func evaluateVoid(_ code: String, filename: String = "<eval>") throws {
        let _ = try evaluate(code, filename: filename)
    }
    
    public func evaluateNumber(_ code: String, filename: String = "<eval>") throws -> Double {
        let result = try evaluate(code, filename: filename)
        return try result.toDouble()
    }
    
    public func evaluateString(_ code: String, filename: String = "<eval>") throws -> String {
        let result = try evaluate(code, filename: filename)
        return try result.toString()
    }
    
    public func evaluateBool(_ code: String, filename: String = "<eval>") throws -> Bool {
        let result = try evaluate(code, filename: filename)
        return result.toBool()
    }
}