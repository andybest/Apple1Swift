//
//  A1EmulatorController.swift
//  Apple1Emulator
//
//  Created by Andy Best on 09/09/2016.
//  Copyright © 2016 Andy Best. All rights reserved.
//

import Foundation

class A1EmulatorController : A1EmulatorDelegate, SerialWindowDelegate {
    var serialWindowController: SerialWindowController?
    var emulator = A1Emulator()
    var timer: Timer?
    
    init() {
        self.serialWindowController = SerialWindowController(windowNibName: "SerialWindow")
        self.serialWindowController!.showWindow(self)
        self.serialWindowController?.delegate = self
        
        emulator.delegate = self
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    @objc func timerFired() {
        _ = emulator.cpu.runCycles(10000)
    }
    
    
    // MARK - A1EmulatorDelegate
    func emulatorDidSendSerial(_ value: UInt8) {
        self.serialWindowController!.processSerialData(value)
    }
    
    // MARK - SerialWindowDelegate
    func consoleDidSendSerial(_ value: UInt8) {
        self.emulator.serialSent(value)
    }
}
