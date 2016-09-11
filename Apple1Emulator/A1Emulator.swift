//
//  A1Emulator.swift
//  Apple1Emulator
//
//  Created by Andy Best on 09/09/2016.
//  Copyright © 2016 Andy Best. All rights reserved.
//

import Foundation
import Cocoa

protocol A1EmulatorDelegate {
    func emulatorDidSendSerial(_ value: UInt8)
}

class A1Emulator {
    
    // Register Addresses
    let RegisterKeyboardInput: UInt16   = 0xD010
    let RegisterKeyboardControl: UInt16 = 0xD011
    let RegisterDisplayOutput: UInt16   = 0xD012
    let RegisterDisplayControl: UInt16  = 0xD013
    
    var ram: [UInt8]
    var cpu: CPU6502
    
    var keyboardByte: UInt8?
    
    var delegate:  A1EmulatorDelegate?
    
    init() {
        ram = [UInt8](repeating:0, count: 65536)
        
        cpu = CPU6502()
        cpu.readMemoryCallback = readMemory
        cpu.writeMemoryCallback = writeMemory
        
        let monitorPath = Bundle.main.path(forResource: "wozmon", ofType: "hex")
        cpu.loadHexFileToMemory(monitorPath!)
    }
    
    // MARK - Serial Sent
    func serialSent(_ value: UInt8) {
        if(value == 0x0A)
        {
            // Convert line feed to carriage return
            keyboardByte = 0x0D
        } else {
            keyboardByte = value
        }
    }
    
    // MARK - Memory callbacks
    
    func readMemory(_ address: UInt16) -> UInt8 {
        if(address == RegisterKeyboardInput) {             // Keyboard input
            if keyboardByte != nil {
                defer { keyboardByte = nil }
                return keyboardByte! | 0x80
            }
            return 0x00
        } else if address == RegisterKeyboardControl {       // Return pressed
            if(keyboardByte != nil) {
                return 0x80
            }
            return 0x00
        } else if address == RegisterDisplayControl {
            return 0x80
        }else {
            return ram[Int(address)]
        }
    }
    
    func writeMemory(_ address: UInt16, value: UInt8) {
        if(address == RegisterDisplayOutput) {             // Display out
            if((delegate) != nil)
            {
                if value == 0x8D {      // New line
                    delegate!.emulatorDidSendSerial(0x0A)
                } else {
                    let output = value & 0x7F
                    delegate!.emulatorDidSendSerial(output)
                }
            }
        } else if address == RegisterDisplayControl {       // Display new line
            
        } else {
            ram[Int(address)] = value
        }
    }
    
}
