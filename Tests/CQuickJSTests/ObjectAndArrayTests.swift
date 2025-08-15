import Testing
import CQuickJS

@Suite("Objects and Arrays")
struct ObjectAndArrayTests {
    
    @Test func arrayCreationAndAccess() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        
        let code = "[1, 2, 3, 'hello']"
        let result = JS_Eval(context, code, code.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context, result) }
        
        #expect(!JS_IsException(result))
        #expect(JS_IsArray(result))
        
        let lengthProp = JS_GetPropertyStr(context, result, "length")
        defer { JS_FreeValue(context, lengthProp) }
        var length: Int32 = 0
        JS_ToInt32(context, &length, lengthProp)
        #expect(length == 4)
        
        let firstElement = JS_GetPropertyUint32(context, result, 0)
        defer { JS_FreeValue(context, firstElement) }
        var firstVal: Int32 = 0
        JS_ToInt32(context, &firstVal, firstElement)
        #expect(firstVal == 1)
    }
    
    @Test func objectCreationAndPropertyAccess() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        
        let code = "({name: 'Test', value: 42})"
        let result = JS_Eval(context, code, code.utf8.count, "<eval>", 0)
        defer { JS_FreeValue(context, result) }
        
        #expect(!JS_IsException(result))
        #expect(JS_IsObject(result))
        
        let nameProp = JS_GetPropertyStr(context, result, "name")
        defer { JS_FreeValue(context, nameProp) }
        let nameStr = JS_ToCString(context, nameProp)
        defer { JS_FreeCString(context, nameStr) }
        #expect(String(cString: nameStr!) == "Test")
        
        let valueProp = JS_GetPropertyStr(context, result, "value")
        defer { JS_FreeValue(context, valueProp) }
        var value: Int32 = 0
        JS_ToInt32(context, &value, valueProp)
        #expect(value == 42)
    }
    
    @Test func propertySetAndGet() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        
        let obj = JS_NewObject(context)
        defer { JS_FreeValue(context, obj) }
        let key = "testKey"
        let value = JS_NewString(context, "testValue")
        
        let setResult = JS_SetPropertyStr(context, obj, key, value)
        #expect(setResult >= 0)
        
        let getValue = JS_GetPropertyStr(context, obj, key)
        defer { JS_FreeValue(context, getValue) }
        let getStr = JS_ToCString(context, getValue)
        defer { JS_FreeCString(context, getStr) }
        #expect(String(cString: getStr!) == "testValue")
    }
}