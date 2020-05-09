import UIKit

struct ColorPalette {
  let textColor: UIColor = .black
  let backgroundColor: UIColor = .white
  let accentColor: UIColor

  static var orange = ColorPalette(accentColor: .quinceJelly)
  static var red    = ColorPalette(accentColor: .valenciaPink)
  static var green  = ColorPalette(accentColor: .pureApple)
  static var blue   = ColorPalette(accentColor: .greenlandGreen)
  static var pink   = ColorPalette(accentColor: .steelPink)
  static var purple = ColorPalette(accentColor: .blurple)
  static var navy   = ColorPalette(accentColor: .deepCove)

  static var all: [ColorPalette] = [.orange, .red, .green, .blue, .pink, .purple, .navy]

  static func hash(string: String?) -> ColorPalette {
    let index = abs(string.hashValue) % all.count
    return all[index]
  }

  static func from(string: String?) -> ColorPalette? {
    switch string {
    case "orange": return .orange
    case "red":    return .red
    case "green":  return .green
    case "blue":   return .blue
    case "pink":   return .pink
    case "purple": return .purple
    case "navy":   return .navy
    default:       return nil
    }
  }
}

extension UIColor {
  // https://www.ralfebert.de/snippets/ios/swift-uicolor-rgb-extension/
  convenience init(hex: Int, alpha: CGFloat = 1.0) {
    let r = CGFloat((hex & 0xff0000) >> 16) / 255
    let g = CGFloat((hex & 0x00ff00) >>  8) / 255
    let b = CGFloat((hex & 0x0000ff)      ) / 255

    self.init(red: r, green: g, blue: b, alpha: alpha)
  }

  static let spicedNectarine = UIColor(hex: 0xFFBE76)
  static let quinceJelly     = UIColor(hex: 0xF0932B)
  static let pinkGlamour     = UIColor(hex: 0xE057FD)
  static let valenciaPink    = UIColor(hex: 0xBE2DDD)
  static let juneBud         = UIColor(hex: 0xBADC58)
  static let pureApple       = UIColor(hex: 0x8FC452)
  static let middleBlue      = UIColor(hex: 0x7ED6DF)
  static let greenlandGreen  = UIColor(hex: 0x22A6B3)
  static let heliotrope      = UIColor(hex: 0xE057FD)
  static let steelPink       = UIColor(hex: 0xBE2DDD)
  static let exodusFruit     = UIColor(hex: 0x696DE0)
  static let blurple         = UIColor(hex: 0x4734D4)
  static let deepKoamaru     = UIColor(hex: 0x2F336B)
  static let deepCove        = UIColor(hex: 0x130F40)
}
