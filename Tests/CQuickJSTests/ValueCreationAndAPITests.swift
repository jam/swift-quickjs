import Testing
import CQuickJS

@Suite("Value Creation and Core APIs")
struct ValueCreationAndAPITests {
    
    @Test func valueCreationAPIs() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        
        let intVal = JS_NewInt32(context, 42)
        defer { JS_FreeValue(context, intVal) }
        #expect(JS_IsNumber(intVal))
        var intResult: Int32 = 0
        JS_ToInt32(context, &intResult, intVal)
        #expect(intResult == 42)
        
        let doubleVal = JS_NewFloat64(context, 3.14159)
        defer { JS_FreeValue(context, doubleVal) }
        #expect(JS_IsNumber(doubleVal))
        var doubleResult: Double = 0
        JS_ToFloat64(context, &doubleResult, doubleVal)
        #expect(abs(doubleResult - 3.14159) < 0.00001)
        
        let stringVal = JS_NewString(context, "Hello")
        defer { JS_FreeValue(context, stringVal) }
        #expect(JS_IsString(stringVal))
        let stringResult = JS_ToCString(context, stringVal)
        defer { JS_FreeCString(context, stringResult) }
        #expect(String(cString: stringResult!) == "Hello")
        
        let boolVal = JS_NewBool(context, true)
        defer { JS_FreeValue(context, boolVal) }
        #expect(JS_IsBool(boolVal))
        #expect(JS_ToBool(context, boolVal) == 1)
        
        let objVal = JS_NewObject(context)
        defer { JS_FreeValue(context, objVal) }
        #expect(JS_IsObject(objVal))
        
        let arrayVal = JS_NewArray(context)
        defer { JS_FreeValue(context, arrayVal) }
        #expect(JS_IsArray(arrayVal))
    }
    
    @Test func atomCreationAndManagement() {
        let runtime = JS_NewRuntime()
        defer { JS_FreeRuntime(runtime) }
        
        let context = JS_NewContext(runtime)
        defer { JS_FreeContext(context) }
        
        let propName = "testProperty"
        let atom = JS_NewAtom(context, propName)
        defer { JS_FreeAtom(context, atom) }
        #expect(atom != 0)
        
        let atomStr = JS_AtomToCString(context, atom)
        defer { JS_FreeCString(context, atomStr) }
        #expect(String(cString: atomStr!) == propName)
    }
}