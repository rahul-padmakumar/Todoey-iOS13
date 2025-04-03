//
//  ColorExtensions.swift
//  Todoey
//
//  Created by Rahul Padmakumar on 03/04/25.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import UIKit

extension CGFloat{
    static func random() -> CGFloat{
        return CGFloat(arc4random())/CGFloat(UInt32.max)
    }
}
extension UIColor{
    static func random() -> UIColor{
        return UIColor(
            red: .random(),
            green: .random(),
            blue: .random(),
            alpha: 1
        )
    }
    func getContrastColor() -> UIColor{
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let lum = 0.2126 * r + 0.7152 * g + 0.0722 * b
        print(a)
        return  a >= 0.5 ? lum < 0.50 ? .white : .black : .black
    }
    func getHexValue() -> String{
        let components = cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        return String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
    }
}

extension String{
    func getUIColor() -> UIColor{
        var colorString = trimmingCharacters(in: .whitespacesAndNewlines)
        colorString = colorString.replacingOccurrences(of: "#", with: "").uppercased()
        let alpha: CGFloat = 1.0
        let red: CGFloat = colorComponentFrom(colorString: colorString, start: 0, length: 2)
        let green: CGFloat = self.colorComponentFrom(colorString: colorString, start: 2, length: 2)
            let blue: CGFloat = self.colorComponentFrom(colorString: colorString, start: 4, length: 2)

            let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
            return color
    }
    
    private func colorComponentFrom(colorString: String, start: Int, length: Int) -> CGFloat {

        let startIndex = colorString.index(colorString.startIndex, offsetBy: start)
        let endIndex = colorString.index(startIndex, offsetBy: length)
        let subString = colorString[startIndex..<endIndex]
        let fullHexString = length == 2 ? subString : "\(subString)\(subString)"
        var hexComponent: UInt64 = 0

        guard Scanner(string: String(fullHexString)).scanHexInt64(&hexComponent) else {
            return 0
        }
        let hexFloat: CGFloat = CGFloat(hexComponent)
        let floatValue: CGFloat = CGFloat(hexFloat / 255.0)
        return floatValue
    }
}
