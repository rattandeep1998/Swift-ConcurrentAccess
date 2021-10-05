//
//  ConcurrentAccessUnsafeDictTests.swift
//  ConcurrentAccessTests
//
//  Created by rsingh26 on 03/10/21.
//

import XCTest
@testable import ConcurrentAccess

class ConcurrentAccessUnsafeDictTests: XCTestCase {
    
    static var sut = ViewController.dict
    
    func testUnsafeDictConcurrentQueue() {
        /// This is on unsafe dictionary and we might see a crash almost everytime here.
        /// This is happening because we are trying to do simulatneous read and write resulting in readers-writers problem.

        let dispatchQueue = DispatchQueue(label: "Concurrent Queue", qos: .userInitiated, attributes: .concurrent)
        
        let write: () -> String = {
            let key = UUID().uuidString
            dispatchQueue.async {
                ConcurrentAccessUnsafeDictTests.sut[key] = UUID().uuidString
            }
            return key
        }
        
        let read: (String) -> Void = { key in
            dispatchQueue.async {
                _ = ConcurrentAccessUnsafeDictTests.sut[key]
            }
        }
        
        for _ in 0..<100 {
            read(write())
        }
    }
    
    func testUnsafeDictionarySerialQueue() {
        /// This is on unsafe dictionary and we will still not see a crash here, since we are accessing this on a serial queue.
        /// By default, dispatch queue gives a serial queue

        let dispatchQueue = DispatchQueue(label: "Concurrent Queue", qos: .userInitiated)
        
        let write: () -> String = {
            let key = UUID().uuidString
            dispatchQueue.async {
                ConcurrentAccessUnsafeDictTests.sut[key] = UUID().uuidString
            }
            return key
        }
        
        let read: (String) -> Void = { key in
            dispatchQueue.async {
                _ = ConcurrentAccessUnsafeDictTests.sut[key]
            }
        }
        
        for _ in 0..<100 {
            read(write())
        }
    }
    
    func testUnsafeDictionaryConcurrentQueueWithBarrier() {
        /// This is on unsafe dictionary and to handle concurrent read write using barrier flags.
        let dispatchQueue = DispatchQueue(label: "Concurrent Queue", qos: .userInitiated, attributes: .concurrent)
        let write: () -> String = {
            let key = UUID().uuidString
            dispatchQueue.async(flags: .barrier) {
                ConcurrentAccessUnsafeDictTests.sut[key] = UUID().uuidString
            }
            return key
        }
        
        let read: (String) -> Void = { key in
            dispatchQueue.async(flags: .barrier) {
                _ = ConcurrentAccessUnsafeDictTests.sut[key]
            }
        }
        
        for _ in 0..<100 {
            read(write())
        }
    }
}
