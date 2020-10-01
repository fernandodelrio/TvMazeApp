//
//  main.swift
//  App
//
//  Created by Fernando Henrique Bonfim Moreno Del Rio on 10/1/20.
//

import UIKit

// This snippet helps to avoid wrong false positive code coverage, by removing the app delegate from the unit tests.

// Check if it's an unit test
let isUnitTest = NSClassFromString("XCTest") != nil

// Mock the app delegate if it's an unit test
let appDelegateClass = isUnitTest ? nil : NSStringFromClass(AppDelegate.self)

let args = UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
_ = UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, appDelegateClass)
