import Testing
import QuickJSKit

@Suite("Error Handling and Edge Cases")
struct ErrorHandlingTests {
    
    @Test func errorHandlingWithDetails() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        do {
            let _ = try context.evaluate("throw new Error('Custom error message');")
            #expect(Bool(false), "Should have thrown an error")
        } catch let error as JSError {
            switch error {
            case .evaluationFailed(let message, let filename, _):
                #expect(message?.contains("Custom error message") == true)
                #expect(filename == "<eval>")
            default:
                #expect(Bool(false), "Wrong error type")
            }
        }
    }
    
    @Test func conversionErrorHandling() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        // Test a syntax error which definitely throws
        do {
            let _ = try context.evaluate("invalid syntax {{{")
            #expect(Bool(false), "Should have thrown syntax error")
        } catch let error as JSError {
            switch error {
            case .evaluationFailed(_, _, _):
                // Expected - syntax errors throw evaluation failures
                break
            default:
                #expect(Bool(false), "Wrong error type")
            }
        }
    }
}