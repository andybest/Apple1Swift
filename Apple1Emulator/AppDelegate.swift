//
//  AppDelegate.swift
//  Apple1Emulator
//
//  Created by Andy Best on 09/09/2016.
//  Copyright © 2016 Andy Best. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var emulatorController : A1EmulatorController?


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        emulatorController = A1EmulatorController()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

