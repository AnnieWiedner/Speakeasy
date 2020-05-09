import UIKit
import Cartography
import Moya

class CardsViewController: UIViewController {

  let helpImageView = UIImageView(image: #imageLiteral(resourceName: "help"))
  let squiggleImageView = UIImageView(image: #imageLiteral(resourceName: "squiggle"))
  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0.0
    layout.minimumInteritemSpacing = 0.0
    layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)

    return UICollectionView(frame: .zero, collectionViewLayout: layout)
  }()

  var cards: [Card] = [] {
    didSet {
      collectionView.reloadData()
    }
  }
//    Card(questionText: "Are you introverted or extroverted?", colorPalette: .orange),
//    Card(questionText: "Debate this: Nickelback isn't that bad.", colorPalette: .red),
//    Card(questionText: "Kanye or Taylor Swift?", colorPalette: .green),
//    Card(questionText: "Who's the first person you'd call if you got arrested?", colorPalette: .blue),
//    Card(questionText: "Is it allowable to fill a free water cup with soda water?", colorPalette: .pink),
//    Card(questionText: "N*SYNC or Backstreet Boys?", colorPalette: .purple),
//    Card(questionText: "Is Christmas music allowed before Thanksgiving?", colorPalette: .navy)
//  ]

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.isPagingEnabled = true

    collectionView.register(CardCell.self, forCellWithReuseIdentifier: CardCell.reuseIdentifier)

    constrain(collectionView, view) { collectionView, view in
      collectionView.edges == view.edges
    }

    let tap = UITapGestureRecognizer(target: self, action: #selector(tapped(gestureRecognizer:)))
    collectionView.addGestureRecognizer(tap)
    loadQuestions()
    
    collectionView.backgroundColor = .white
    view.addSubview(helpImageView)
    view.addSubview(squiggleImageView)
    
    constrain(helpImageView, squiggleImageView, view) {
      helpImageView, squiggleImageView, superview in

      helpImageView.top == superview.topMargin
      helpImageView.right == superview.rightMargin - 10
      
      squiggleImageView.right == superview.right
      squiggleImageView.bottom == superview.bottom
    }
  }

  @objc func tapped(gestureRecognizer: UITapGestureRecognizer) {
    let location = gestureRecognizer.location(in: view)
    let indexPath = collectionView.indexPathsForVisibleItems.first.map { indexPath in
      location.x > collectionView.frame.width / 2 ? indexPath.next() : indexPath.previous()
    }
    
    if let path = indexPath, path.item < cards.count, path.item >= 0 {
      collectionView.scrollToItem(at: path, at: .left, animated: true)
    }
  }

  func loadQuestions() {
    let provider = MoyaProvider<Airtable>()
    provider.request(.questions) { result in
      switch result {
      case let .success(response):
        if response.statusCode == 200 {
          print(String(data: response.data, encoding: .utf8))
          do {
            let airtableResponse = try JSONDecoder().decode(AirtableResponse.self, from: response.data)
            self.cards = airtableResponse.records.map { $0.fields }.shuffled()
          } catch {
            print("error \(error)")
          }
        } else {
          print("status code \(response.statusCode)")
        }
      case let .failure(error):
        print("error \(error)")
      }
    }
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .default
  }
}

extension CardsViewController: UICollectionViewDelegate {

}

extension CardsViewController: UICollectionViewDataSource {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cards.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCell.reuseIdentifier, for: indexPath) as! CardCell
    let card = cards[indexPath.row]
    print(card.category)
    cell.categoryText = card.category
    cell.questionText = card.question
    cell.subtext = card.subtext
    cell.colorPalette = card.colorPalette ?? .hash(string: card.question)
    return cell
  }
}

extension IndexPath {
  func next() -> IndexPath {
    return IndexPath(item: item + 1, section: section)
  }

  func previous() -> IndexPath {
    return IndexPath(item: item - 1, section: section)
  }
}
