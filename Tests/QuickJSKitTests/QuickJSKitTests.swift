import Testing
import QuickJSKit

@Suite("QuickJSKit Wrapper Tests")
struct QuickJSKitTests {
    
    @Test func runtimeCreation() throws {
        let _ = try JSRuntime()
        // Should not crash - success is creating without throwing
    }
    
    @Test func contextCreation() throws {
        let runtime = try JSRuntime()
        let _ = try JSContext(runtime: runtime)
        // Should not crash - success is creating without throwing
    }
    
    @Test func basicEvaluation() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        let result = try context.evaluateNumber("2 + 3")
        #expect(result == 5.0)
    }
    
    @Test func stringEvaluation() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        let result = try context.evaluateString("'Hello, Swift!'")
        #expect(result == "Hello, Swift!")
    }
    
    @Test func booleanEvaluation() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        let trueResult = try context.evaluateBool("true")
        #expect(trueResult == true)
        
        let falseResult = try context.evaluateBool("false")
        #expect(falseResult == false)
    }
    
    @Test func valueTypeChecking() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        let numberValue = try context.evaluate("42")
        #expect(numberValue.isNumber)
        #expect(!numberValue.isString)
        
        let stringValue = try context.evaluate("'test'")
        #expect(stringValue.isString)
        #expect(!stringValue.isNumber)
        
        let boolValue = try context.evaluate("true")
        #expect(boolValue.isBool)
    }
    
    @Test func functionExecution() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        let result = try context.evaluateNumber("function add(a, b) { return a + b; } add(10, 20);")
        #expect(result == 30.0)
    }
    
    @Test func arrayAndObjectHandling() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        let arrayValue = try context.evaluate("[1, 2, 3]")
        #expect(arrayValue.isArray)
        
        let objectValue = try context.evaluate("({name: 'test', value: 42})")
        #expect(objectValue.isObject)
    }
    
    @Test func garbageCollection() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        // Create some objects and run GC
        try context.evaluateVoid("for(let i = 0; i < 100; i++) { let obj = {data: new Array(1000).fill(i)}; }")
        runtime.runGarbageCollection()
        
        // Should not crash
    }
    
    @Test func errorHandlingWithDetails() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        do {
            let _ = try context.evaluate("throw new Error('Custom error message');")
            #expect(false, "Should have thrown an error")
        } catch let error as JSError {
            switch error {
            case .evaluationFailed(let message, let filename, _):
                #expect(message?.contains("Custom error message") == true)
                #expect(filename == "<eval>")
            default:
                #expect(false, "Wrong error type")
            }
        }
    }
    
    @Test func conversionErrorHandling() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        // QuickJS actually converts strings to NaN, which doesn't throw
        // Let's test a case that actually fails - objects to numbers
        let objectValue = try context.evaluate("({name: 'test'})")
        
        do {
            let _ = try objectValue.toDouble()
            #expect(false, "Should have thrown conversion error")
        } catch let error as JSError {
            switch error {
            case .conversionFailed(let from, let to):
                #expect(from == "Object")
                #expect(to == "Double")
            default:
                #expect(false, "Wrong error type")
            }
        }
    }
    
    @Test func typeInferredEvaluation() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        // Type inference magic! ✨
        let intResult: Int = try context.evaluate("2 + 3")
        #expect(intResult == 5)
        
        let doubleResult: Double = try context.evaluate("3.14159")
        #expect(abs(doubleResult - 3.14159) < 0.00001)
        
        let stringResult: String = try context.evaluate("'Hello, ' + 'TypeScript!'")
        #expect(stringResult == "Hello, TypeScript!")
        
        let boolResult: Bool = try context.evaluate("true && false")
        #expect(boolResult == false)
        
        let jsValueResult: JSValue = try context.evaluate("({key: 'value'})")
        #expect(jsValueResult.isObject)
    }
}