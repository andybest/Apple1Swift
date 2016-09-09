//
//  SerialWindowController.swift
//  Apple1Emulator
//
//  Created by Andy Best on 09/09/2016.
//  Copyright © 2016 Andy Best. All rights reserved.
//

import Foundation
import Cocoa

protocol SerialWindowDelegate {
    func consoleDidSendSerial(_ value: UInt8)
}

class SerialWindowController: NSWindowController, NSTextViewDelegate, NSTextDelegate, ConsoleDelegate {
    
    @IBOutlet var serialTextView: ConsoleTextView!
    var delegate: SerialWindowDelegate?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        serialTextView.delegate = self
    }
    
    func processSerialData(_ value: UInt8) {
        serialTextView.processSerialData(data: value)
    }
    
    // MARK - ConsoleDelegate
    func consoleDidSendSerial(_ value: UInt8) {
        if self.delegate != nil {
            self.delegate!.consoleDidSendSerial(value)
        }
    }
    
}
