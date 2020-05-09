import UIKit
import Cartography
import MarkdownKit

class TutorialCell: UICollectionViewCell {
  static let reuseIdentifier = "TutorialCell"

  let titleLabel = UILabel()
  let instructionsLabel = UILabel()
  let imageView = UIImageView()

  var step: TutorialStep? {
    didSet {
      titleLabel.text = step?.title
      instructionsLabel.text = step?.instructions
      imageView.image = step?.imageName.map { UIImage(named: $0)! }
    }
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    titleLabel.numberOfLines = 0
    titleLabel.adjustsFontForContentSizeCategory = true
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont(name: "SharpSansDisplayNo1-SemiBold", size: 38)!
    
    contentView.addSubview(titleLabel)

    instructionsLabel.numberOfLines = 0
    instructionsLabel.adjustsFontForContentSizeCategory = true
    instructionsLabel.textAlignment = .center
    instructionsLabel.font = UIFont(name: "SharpSansDisplayNo1-SemiBold", size: 15)!

    contentView.addSubview(instructionsLabel)
//    contentView.backgroundColor = .red

    imageView.image = UIImage(named: "scroll")
    contentView.addSubview(imageView)
    
    constrain(titleLabel, instructionsLabel, imageView, contentView) {
      titleLabel, instructionsLabel, imageView, view in
      
      titleLabel.top == view.top
      titleLabel.centerX == view.centerX
      titleLabel.width == 250

      instructionsLabel.centerX == view.centerX
      instructionsLabel.bottom == view.bottom
      instructionsLabel.width == 250
      
      imageView.center == view.center
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct TutorialStep: Codable {
  let title: String
  let instructions: String?
  let imageName: String?
}
