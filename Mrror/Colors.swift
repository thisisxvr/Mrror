//
//  Colors.swift
//  Mrror
//
//  Created by Xavier Francis on 21/08/17.
//  Copyright © 2017 Xavier Francis. All rights reserved.
//

import UIKit

extension UIColor
{
    class var transparentGreen : UIColor
    {
        return UIColor(red: 0, green: 255/255, blue: 0, alpha: 0.5)
    }
    
    class var transparentBlue : UIColor
    {
        return UIColor(red: 0, green: 0, blue: 255/255, alpha: 0.5)
    }
    
    class var transparentRed: UIColor
    {
        return UIColor(red: 255, green: 0, blue: 255/255, alpha: 0.5)
    }
    
    class var veryDarkGreen: UIColor
    {
        return UIColor.rgb(fromHex: 0x008110)
    }
    
    class func rgb(fromHex: Int) -> UIColor
    {
        
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
