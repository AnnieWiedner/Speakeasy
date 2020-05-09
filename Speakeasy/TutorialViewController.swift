import UIKit
import Cartography
import Moya

class TutorialViewController: UIViewController {
  
  let button = UIButton(type: .roundedRect)
  
  let layoutSize = CGSize(width: 300, height: 400)
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0.0
    layout.minimumInteritemSpacing = 0.0
    layout.itemSize = layoutSize

    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()

  let pageControl = UIPageControl()
  
  let steps = [
    TutorialStep(
      title: "skip around",
      instructions: "swipe left and right to scan through the deck",
      imageName: "scroll"
    ),
    TutorialStep(
      title: "shuffle",
      instructions: "shake your phone to shuffle the deck",
      imageName: "shake"
    ),
    TutorialStep(
      title: "unlock more cards",
      instructions: "access hundreds of speakeasy conversation starters for just $3.99",
      imageName: "lock"
    )
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false

    collectionView.register(TutorialCell.self, forCellWithReuseIdentifier: TutorialCell.reuseIdentifier)

    view.addSubview(pageControl)
    pageControl.currentPage = 0
    pageControl.numberOfPages = steps.count
    pageControl.pageIndicatorTintColor = .lightGray
    pageControl.currentPageIndicatorTintColor = .pinkGlamour

    view.addSubview(button)
    button.setTitle("NEXT", for: .normal)
    button.titleLabel?.font = UIFont(name: "SharpSansDisplayNo1-Bold", size: 14)!
    button.backgroundColor = .deepKoamaru
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 21
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

    constrain(collectionView, pageControl, button, view) { collectionView, pageControl, button, view in
      let padding: CGFloat = 20

      collectionView.center == view.center
      collectionView.height == layoutSize.height
      collectionView.width == layoutSize.width
      
      pageControl.centerX == view.centerX
      pageControl.top == collectionView.bottom + padding
      
      button.centerX == view.centerX
      button.top == pageControl.bottom + padding
      button.width == 200
      button.height == 42
    }
    
    collectionView.backgroundColor = .white
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
  
  @objc func buttonTapped(sender: UIButton) {
    let next = 2 // make this the next
    let indexPath = IndexPath(row: next, section: 0)
    pageControl.currentPage = next
    collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
  }
}

extension TutorialViewController: UICollectionViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if let lastCell = collectionView.visibleCells.last {
      pageControl.currentPage = (collectionView.indexPath(for: lastCell)?.row)!
    }
  }
}

extension TutorialViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return steps.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TutorialCell.reuseIdentifier, for: indexPath) as! TutorialCell
    cell.step = steps[indexPath.row]
    return cell
  }
}
