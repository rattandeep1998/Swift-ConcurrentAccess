//
//  Lock.swift
//  ConcurrentAccess
//
//  Created by rsingh26 on 05/10/21.
//

import Foundation

internal protocol Lock {
    func lock()
    
    func unlock()
}

internal extension Lock {
    /// Performs the action once the lock is acquired. Once the action returns, the lock is released.
    @discardableResult func `do`<T>(_ action: () throws -> T) rethrows -> T {
        lock()
        let value = try action()
        unlock()
        return value
    }
}
