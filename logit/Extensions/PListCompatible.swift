//
//  PListCompatible.swift
//  logit
//
//  Created by Filippo Zaffoni on 06/06/24.
//

import Foundation

public protocol PlistCompatible { }

// MARK: - UserDefaults Compatibile Types
extension String: PlistCompatible { }
extension Int: PlistCompatible { }
extension Double: PlistCompatible { }
extension Float: PlistCompatible { }
extension Bool: PlistCompatible { }
extension Date: PlistCompatible { }
extension Data: PlistCompatible { }
extension Array: PlistCompatible where Element: PlistCompatible { }
extension Dictionary: PlistCompatible where Key: PlistCompatible, Value: PlistCompatible { }
