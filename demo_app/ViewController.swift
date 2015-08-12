//
//  ViewController.swift
//  demo_app
//
//  Created by Gabriele on 12/08/15.
//  Copyright © 2015 Gabriele Pongelli. All rights reserved.
//

import UIKit

import GPSafeSwiftPointer

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let gpSafe = GPSafeSwiftPointer<UInt32>(allocatedMemory: 2)
        gpSafe[0] = 1054
        gpSafe[1] = 7
        
        print(gpSafe.getByteArray())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

