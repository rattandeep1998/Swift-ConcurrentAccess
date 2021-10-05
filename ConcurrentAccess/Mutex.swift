//
//  Mutex.swift
//  ConcurrentAccess
//
//  Created by rsingh26 on 05/10/21.
//

import Foundation

internal final class Mutex: Lock {
    private var mutex: pthread_mutex_t = {
        var mutex = pthread_mutex_t()
        pthread_mutex_init(&mutex, nil)
        return mutex
    }()

    func lock() {
        pthread_mutex_lock(&mutex)
    }

    func unlock() {
        pthread_mutex_unlock(&mutex)
    }
    
    deinit {
        pthread_mutex_destroy(&mutex)
    }
}
