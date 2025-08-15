import Testing
import CQuickJS

@Test func runtimeCreationAndDestruction() {
    let runtime = JS_NewRuntime()
    defer { JS_FreeRuntime(runtime) }
    
    #expect(runtime != nil)
}

@Suite("Runtime and Context Management")
struct RuntimeAndContextTests {
    
    @Test func contextCreationAndDestruction() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        #expect(runtime != nil)
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        #expect(context != nil)
    }
    
    @Test func multipleContexts() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context1 = JS_NewContext(runtime)
        defer { JS_FreeContext(context1) }
        
        let context2 = JS_NewContext(runtime)
        defer { JS_FreeContext(context2) }
        
        let code1 = "var x = 10;"
        let result1 = JS_Eval(context1, code1, code1.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context1, result1) }
        
        let code2 = "var x = 20;"
        let result2 = JS_Eval(context2, code2, code2.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context2, result2) }
        
        let getValue1 = "x"
        let value1 = JS_Eval(context1, getValue1, getValue1.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context1, value1) }
        var val1: Int32 = 0
        JS_ToInt32(context1, &val1, value1)
        #expect(val1 == 10)
        
        let getValue2 = "x"
        let value2 = JS_Eval(context2, getValue2, getValue2.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context2, value2) }
        var val2: Int32 = 0
        JS_ToInt32(context2, &val2, value2)
        #expect(val2 == 20)
    }
    
    @Test func memoryManagementAndGarbageCollection() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        
        for _ in 0..<100 {
            let code = "({data: new Array(1000).fill('test')})"
            let result = JS_Eval(context, code, code.utf8.count, "<eval>", 0)
            JS_FreeValue(context, result)
        }
        
        JS_RunGC(runtime)
    }
}