//
//  Theme.swift
//  AccountKitSampleSwift
//
//  Created by Julian Shen on 2016/10/9.
//  Copyright © 2016年 cowbay.wtf. All rights reserved.
//

import Foundation
import AccountKit
import UIKit

enum ThemeType:Int {
    case `default`, salmon, yellow, red, dog, bicycle
    
    private static let _descriptions = ["Default", "Salmon", "Yellow", "Red", "Dog", "Bicycle"]
    static let count: Int = {
        var max = 1
        while let _ = ThemeType(rawValue: max) {
            max += 1
        }
        return max
    }()
    
    var description:String {
        get {
            return ThemeType._descriptions[Int(self.rawValue)]
        }
    }
    
    var theme:AKFTheme {
        get {
            switch self {
            case .salmon:
                return AKFTheme.salmonTheme
            case .yellow:
                return AKFTheme.yellowTheme
            case .red:
                return AKFTheme.redTheme
            case .dog:
                return AKFTheme.dogTheme
            case .bicycle:
                return AKFTheme.bicycleTheme
            default:
                return AKFTheme.default()
            }
        }
    }
}

extension AKFTheme {
    static var salmonTheme: AKFTheme {
        let theme = AKFTheme(primaryColor: .white, primaryTextColor: ._colorWithHex(0xff565a5c), secondaryColor: ._colorWithHex(0xccffe5e5), secondaryTextColor: ._colorWithHex(0xff565a5c), statusBarStyle: .default)
        theme.buttonBackgroundColor = ._colorWithHex(0xffff5a5f)
        theme.buttonTextColor = .white
        theme.iconColor = ._colorWithHex(0xffff5a5f)
        theme.inputTextColor = ._colorWithHex(0xff44566b)
        return theme
    }
    
    static var yellowTheme: AKFTheme {
        let theme = AKFTheme.outlineTheme(withPrimaryColor: ._colorWithHex(0xfff4bf56), primaryTextColor: .white, secondaryTextColor: ._colorWithHex(0xff44566b), statusBarStyle: .default)

        theme.buttonTextColor = UIColor.white
        return theme
    }
    
    static var redTheme: AKFTheme {
        let theme = AKFTheme.outlineTheme(withPrimaryColor: ._colorWithHex(0xff333333), primaryTextColor: .white, secondaryTextColor: ._colorWithHex(0xff151515), statusBarStyle: .lightContent)
        
        theme.backgroundColor = ._colorWithHex(0xfff7f7f7)
        theme.buttonBackgroundColor = ._colorWithHex(0xffe02727)
        theme.buttonBorderColor = ._colorWithHex(0xffe02727);
        theme.inputBorderColor = ._colorWithHex(0xffe02727);
        return theme
    }
    
    static var dogTheme: AKFTheme {
        let theme = AKFTheme(primaryColor: .white, primaryTextColor: ._colorWithHex(0xff44566b), secondaryColor: ._colorWithHex(0xccffffff), secondaryTextColor: .white, statusBarStyle: .default)
        theme.backgroundColor = ._colorWithHex(0x994e7e24)
        theme.backgroundImage = UIImage(named: "dog")
        theme.inputTextColor = ._colorWithHex(0xff44566b)
        return theme
    }
    
    static var bicycleTheme: AKFTheme {
        let theme = AKFTheme.outlineTheme(withPrimaryColor: ._colorWithHex(0xffff5a5f), primaryTextColor: .white, secondaryTextColor: .white, statusBarStyle: .lightContent)
        
        theme.backgroundImage = UIImage(named: "bicycle")
        theme.backgroundColor = ._colorWithHex(0x66000000)
        theme.inputBackgroundColor = ._colorWithHex(0x00000000)
        theme.inputBorderColor = .white
        return theme
    }
}

extension UIColor {
    static func _colorWithHex(_ hex: UInt) -> UIColor {
        let alpha = ((CGFloat)((hex & 0xff000000) >> 24)) / 255.0
        let red = ((CGFloat)((hex & 0x00ff0000) >> 16)) / 255.0
        let green = ((CGFloat)((hex & 0x0000ff00) >> 8)) / 255.0
        let blue = ((CGFloat)((hex & 0x000000ff) >> 0)) / 255.0
        
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
