import Testing
import CQuickJS

@Suite("Error Handling")
struct ErrorHandlingTests {
    
    @Test func exceptionHandling() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        
        let code = "throw new Error('Test error');"
        let result = JS_Eval(context, code, code.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context, result) }
        
        #expect(JS_IsException(result))
        
        let exception = JS_GetException(context)
        defer { JS_FreeValue(context, exception) }
        #expect(JS_IsNull(exception) == false)
    }
}