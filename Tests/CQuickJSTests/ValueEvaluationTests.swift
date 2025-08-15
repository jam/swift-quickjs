import Testing
import CQuickJS

@Suite("JavaScript Value Evaluation")
struct ValueEvaluationTests {
    
    @Test func basicJavaScriptEvaluation() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        
        let code = "2 + 3"
        let result = JS_Eval(context, code, code.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context, result) }
        
        #expect(JS_IsException(result) == false)
        #expect(JS_IsNumber(result))
        
        var val: Double = 0
        JS_ToFloat64(context, &val, result)
        #expect(val == 5.0)
    }
    
    @Test func stringEvaluation() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        
        let code = "'Hello, World!'"
        let result = JS_Eval(context, code, code.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context, result) }
        
        #expect(JS_IsException(result) == false)
        #expect(JS_IsString(result))
        
        let cString = JS_ToCString(context, result)
        defer { JS_FreeCString(context, cString) }
        #expect(cString != nil)
        
        let swiftString = String(cString: cString!)
        #expect(swiftString == "Hello, World!")
    }
    
    @Test func booleanEvaluation() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        
        let trueCode = "true"
        let trueResult = JS_Eval(context, trueCode, trueCode.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context, trueResult) }
        #expect(JS_IsException(trueResult) == false)
        #expect(JS_IsBool(trueResult))
        #expect(JS_ToBool(context, trueResult) == 1)
        
        let falseCode = "false"
        let falseResult = JS_Eval(context, falseCode, falseCode.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context, falseResult) }
        #expect(JS_IsException(falseResult) == false)
        #expect(JS_IsBool(falseResult))
        #expect(JS_ToBool(context, falseResult) == 0)
    }
    
    @Test func nullAndUndefinedValues() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        
        let nullCode = "null"
        let nullResult = JS_Eval(context, nullCode, nullCode.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context, nullResult) }
        #expect(JS_IsNull(nullResult))
        
        let undefinedCode = "undefined"
        let undefinedResult = JS_Eval(context, undefinedCode, undefinedCode.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context, undefinedResult) }
        #expect(JS_IsUndefined(undefinedResult))
    }
    
    @Test func functionEvaluation() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        
        let code = "function add(a, b) { return a + b; } add(5, 3);"
        let result = JS_Eval(context, code, code.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context, result) }
        
        #expect(JS_IsException(result) == false)
        #expect(JS_IsNumber(result))
        
        var val: Double = 0
        JS_ToFloat64(context, &val, result)
        #expect(val == 8.0)
    }
    
    @Test func complexExpressionEvaluation() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        
        let code = """
            var obj = {
                nums: [1, 2, 3, 4, 5],
                calculate: function() {
                    return this.nums.reduce((a, b) => a + b, 0);
                }
            };
            obj.calculate();
            """
        
        let result = JS_Eval(context, code, code.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context, result) }
        
        #expect(JS_IsException(result) == false)
        #expect(JS_IsNumber(result))
        
        var val: Double = 0
        JS_ToFloat64(context, &val, result)
        #expect(val == 15.0)
    }
}