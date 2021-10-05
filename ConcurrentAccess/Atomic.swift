//
//  Atomic.swift
//  ConcurrentAccess
//
//  Created by rsingh26 on 05/10/21.
//

import Foundation

/// Atomic wrapper around a value to ensure reads and writes to that value will be performed atomically.
internal class Atomic<T> {
    /// The backing value to which reads and write should be synchronized
    private var value: T

    /// Lock used for ensuring the `value` is only accessed by one thread at a time
    private let lock: Lock

    init(
        _ value: T,
        lock: Lock = Mutex()
    ) {
        self.value = value
        self.lock = lock
    }

    func get() -> T {
        return lock.do { value }
    }

    func set(_ setter: () -> T) {
        lock.do { value = setter() }
    }
    
    /// Operation performed atomically, only one thread can read / write at a time.
    /// Proxy variable is used to read/write to the value of this property.
    @discardableResult func atomically<T>(_ operation: (Proxy) throws -> T) rethrows -> T {
        return try lock.do {
            let proxy: Proxy = Proxy(value)
            let operationValue: T = try operation(proxy)
            self.value = proxy.value
            return operationValue
        }
    }
}

// MARK: + Proxy

internal extension Atomic {
    /// A proxy used during an atomic operation that can be used to get and
    /// set the value in the atomic property.
    class Proxy {
        /// The value stored in this proxy which will then be delivered to the Atomic property once the atomic operation completes.

        var value: T
        /// Initializer
        /// - Parameter value: the value to store in the proxy.
        init(_ value: T) {
            self.value = value
        }
    }
}
