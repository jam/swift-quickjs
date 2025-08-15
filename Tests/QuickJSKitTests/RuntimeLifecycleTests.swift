import Testing
import QuickJSKit

@Suite("Runtime and Context Lifecycle")
struct RuntimeLifecycleTests {
    
    @Test func runtimeCreation() throws {
        let _ = try JSRuntime()
        // Should not crash - success is creating without throwing
    }
    
    @Test func contextCreation() throws {
        let runtime = try JSRuntime()
        let _ = try JSContext(runtime: runtime)
        // Should not crash - success is creating without throwing
    }
    
    @Test func garbageCollection() throws {
        let runtime = try JSRuntime()
        let context = try JSContext(runtime: runtime)
        
        // Create some objects and run GC
        try context.evaluateVoid("for(let i = 0; i < 100; i++) { let obj = {data: new Array(1000).fill(i)}; }")
        runtime.runGarbageCollection()
        
        // Should not crash
    }
}