//
//  UIColor+Extensions.swift
//  DragRacing
//
//  Created by Mohammad Azam on 5/19/18.
//  Copyright © 2018 Mohammad Azam. All rights reserved.
//

import Foundation

extension UIColor {
    
        //  Converted to Swift 4 by Swiftify v4.1.6710 - https://objectivec2swift.com/
        func hexString() -> String {
            
            let components = (self.cgColor.components)!
            
            let r = CGFloat(components[0])
            let g = CGFloat(components[1])
            let b = CGFloat(components[2])
            return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        }
    
   
    static func random() -> UIColor {
        
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
}



