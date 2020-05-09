import UIKit
import Cartography
import MarkdownKit

class CardCell: UICollectionViewCell {
  static let reuseIdentifier = "CardCell"

  let textView = UIView()
  let categoryLabel = UILabel()
  let questionLabel = UILabel()
  let subtextLabel = UILabel()
  
  var colorPalette: ColorPalette = .blue {
    didSet {
      categoryLabel.textColor = colorPalette.accentColor
      questionLabel.textColor = colorPalette.textColor
      subtextLabel.textColor = colorPalette.textColor
      contentView.backgroundColor = colorPalette.backgroundColor
    }
  }

  let categoryFont = UIFont(name: "SharpSansDisplayNo1-Bold", size: 14)!
  let categoryItalicFont = UIFont(name: "SharpSansDisplayNo1-Boldltalic", size: 14)!

  let questionFont = UIFont(name: "SharpSansDisplayNo1-SemiBold", size: 27)!
  let questionItalicFont = UIFont(name: "SharpSansDisplayNo1-SemiBoldItalic", size: 27)!

  let subtextFont = UIFont(name: "SharpSansDisplayNo1-SemiBold", size: 14)!
  let subtextItalicFont = UIFont(name: "SharpSansDisplayNo1-SemiBoldItalic", size: 14)!

  var categoryText: String? {
    didSet {
      categoryLabel.attributedText = NSAttributedString.from(
        markdown: categoryText?.uppercased(),
        font: categoryFont,
        italicFont: categoryItalicFont,
        minimumLineHeight: 18,
        kern: 2
      )
    }
  }
  
  var questionText: String? {
    didSet {
      questionLabel.attributedText = NSAttributedString.from(
        markdown: questionText,
        font: questionFont,
        italicFont: questionItalicFont,
        minimumLineHeight: 35,
        kern: 0.1
      )
    }
  }

  var subtext: String? {
    didSet {
      subtextLabel.attributedText = NSAttributedString.from(
        markdown: subtext,
        font: subtextFont,
        italicFont: subtextItalicFont,
        minimumLineHeight: 18,
        kern: 0.1
      )
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    categoryLabel.adjustsFontForContentSizeCategory = true
    
    textView.addSubview(categoryLabel)
    
    questionLabel.numberOfLines = 0
    questionLabel.adjustsFontForContentSizeCategory = true

    textView.addSubview(questionLabel)

    subtextLabel.numberOfLines = 0
    subtextLabel.adjustsFontForContentSizeCategory = true

    textView.addSubview(subtextLabel)

    constrain(categoryLabel, questionLabel, subtextLabel, textView) {
      categoryLabel, questionLabel, subtextLabel, textView in

      let padding: CGFloat = 26
      
      categoryLabel.top == textView.top
      categoryLabel.left == textView.left
      categoryLabel.right == textView.right
      categoryLabel.bottom == questionLabel.top - padding

      questionLabel.left == textView.left
      questionLabel.right == textView.right
      questionLabel.bottom == subtextLabel.top - padding

      subtextLabel.left == textView.left
      subtextLabel.right == textView.right
      subtextLabel.bottom == textView.bottom
    }

    contentView.addSubview(textView)

    constrain(textView, contentView) {
      textView, superview in

      textView.center == superview.center
      textView.width == 300
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

public extension NSAttributedString {
  func applying(attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
    let copy = NSMutableAttributedString(attributedString: self)
    let range = (string as NSString).range(of: string)
    copy.addAttributes(attributes, range: range)

    return copy
  }

  static func from(markdown: String?, font: UIFont, italicFont: UIFont, minimumLineHeight: CGFloat, kern: CGFloat) -> NSAttributedString? {
    if let markdown = markdown {
      let parser = MarkdownParser(font: font)
      parser.italic.font = italicFont

      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.minimumLineHeight = minimumLineHeight

      return parser.parse(markdown).applying(attributes: [
        .paragraphStyle: paragraphStyle,
        .kern: kern
      ])
    } else {
      return nil
    }
  }
}
