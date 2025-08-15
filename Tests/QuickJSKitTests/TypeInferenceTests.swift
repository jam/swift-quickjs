import Testing
import QuickJSKit

@Suite("Type Inference and Evaluation")
struct TypeInferenceTests {
    
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