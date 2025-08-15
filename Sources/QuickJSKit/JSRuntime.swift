import CQuickJS

public final class JSRuntime {
    private let runtime: OpaquePointer
    
    public init() throws {
        guard let runtime = JS_NewRuntime() else {
            throw JSError.runtimeCreationFailed
        }
        self.runtime = runtime
    }
    
    deinit {
        JS_FreeRuntime(runtime)
    }
    
    internal var rawValue: OpaquePointer {
        return runtime
    }
    
    public func runGarbageCollection() {
        JS_RunGC(runtime)
    }
    
    /// Sets the memory limit for this runtime.
    /// - Parameter limit: Maximum memory in bytes, or 0 for unlimited
    /// - Note: Safe to call on an active runtime, but may trigger GC if current usage exceeds new limit
    public func setMemoryLimit(_ limit: Int) {
        JS_SetMemoryLimit(runtime, limit)
    }
}