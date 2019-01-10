//
//  ViewController.swift
//  DatePickerTest
//
//  Created by Flo on 10.01.19.
//  Copyright © 2019 Test. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @objc dynamic var objectControllerContent : ObjectControllerContent = ObjectControllerContent()
    
    @IBOutlet weak var label: NSTextField!
    @IBAction func btnClicked(_ sender: Any) {
        label.stringValue = "prop_dateTime is \(objectControllerContent.prop_dateTime)"
    }
}

class ObjectControllerContent : NSObject {
    @objc dynamic var prop_dateTime : Date?
}
