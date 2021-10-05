//
//  ViewController.swift
//  ConcurrentAccess
//
//  Created by rsingh26 on 03/10/21.
//

import UIKit

class ViewController: UIViewController {
    
    static var dict: [String:String] = [:]

    static var safeDict: Atomic<[String:String]> = .init([:]) // Using locks
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print(ViewController.dict)
    }
}

