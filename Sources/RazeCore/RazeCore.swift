import UIKit

open class RazeCore {
    
    /// Allows you to convert 6 digit hexadecimal string into a UIColor instance
    /// - Warning: The "#" symbol is stripped from the beggining of the string submitted here
    /// - Parameters:
    ///   - hexString: a 6 digit hexadecimal string.
    ///   - alpha: a number between 0.1 and 1.0 indicating how transparent the color is
    /// - Returns: An UIColor instance defined by `hexString` parameter
    internal class func colorFromHexString(_ hexString: String, alpha: CGFloat = 1) -> UIColor {
        let r, g, b: CGFloat
        let offset = hexString.hasPrefix("#") ? 1 : 0
        let start = hexString.index(hexString.startIndex, offsetBy: offset)
        let hexColor = String(hexString[start...])
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
            g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
            b = CGFloat(hexNumber & 0x0000ff) / 255
            return UIColor(red: r, green: g, blue: b, alpha: alpha)
        }
        return UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
    }
    
    
    /// the best color eva
    public static var razeColor: UIColor {
        return self.colorFromHexString("006736")
    }
    
    
    /// second best color eva
    public static var secondaryRazeColor: UIColor {
        return self.colorFromHexString("FCFFFD")
    }
}
