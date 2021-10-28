//
//  ConcurrentAccessSafeDictTests.swift
//  ConcurrentAccessTests
//
//  Created by rsingh26 on 05/10/21.
//

import XCTest
@testable import ConcurrentAccess

class ConcurrentAccessSafeDictTests: XCTestCase {

    static var sut = ViewController.safeDict

    func testSafeDictionaryConcurrentQueueWithBarrier() {
        /// This is on safe dictionary and to handle concurrent read write using locks.
        
        let dispatchQueue = DispatchQueue(label: "Concurrent Queue", qos: .userInitiated, attributes: .concurrent)
        let write: () -> String = {
            let key = UUID().uuidString
            dispatchQueue.async {
                ConcurrentAccessSafeDictTests.sut.atomically { $0.value[key] = UUID().uuidString }
            }
            return key
        }
        
        let read: (String) -> Void = { key in
            dispatchQueue.async {
                _ = ConcurrentAccessSafeDictTests.sut.get()[key]
            }
        }
        
        for _ in 0..<100 {
            read(write())
        }
    }
}
