import Testing
import QuickJSKit

@Suite("JavaScript Value Types")
struct ValueTypeTests {
    
    @Test func valueTypeChecking() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        let numberValue = try context.evaluate("42")
        #expect(numberValue.isNumber)
        #expect(numberValue.isString == false)
        
        let stringValue = try context.evaluate("'test'")
        #expect(stringValue.isString)
        #expect(stringValue.isNumber == false)
        
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
}