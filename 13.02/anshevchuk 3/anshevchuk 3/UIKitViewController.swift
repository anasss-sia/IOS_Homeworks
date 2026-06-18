import UIKit

final class CoffeeGridUIKitViewController: UIViewController {
    
    private struct SectionModel {
        let title: String
        let items: [String]
    }
    
    private let sections: [SectionModel] = [
        SectionModel(
            title: "Hot",
            items: ["☕️ Espresso","🥛 Latte","🍫 Mocha","🍵 Cappuccino","🫖 Americano"]
        ),
        
        SectionModel(
            title: "Cold",
            items: ["🧊 Iced Latte","🧋 Cold Brew","🍹 Frappé","🥤 Iced Mocha","🧊 Iced Americano"]
        )
    ]
    
    
    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        
        layout.sectionInset = UIEdgeInsets(
            top: 12,
            left: 16,
            bottom: 24,
            right: 16
        )
        
        layout.headerReferenceSize = CGSize(width: 1, height: 36)
        
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        cv.backgroundColor = UIColor(named: "CoffeeBackground")
        
        cv.dataSource = self
        cv.delegate = self
        
        cv.register(
            CoffeeCell.self,
            forCellWithReuseIdentifier: CoffeeCell.reuseId
        )
        
        cv.register(
            CoffeeHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CoffeeHeaderView.reuseId
        )
        
        return cv
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "CoffeeBackground")
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
}

extension CoffeeGridUIKitViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CoffeeCell.reuseId,
            for: indexPath
        ) as! CoffeeCell
        
        let coffee = sections[indexPath.section].items[indexPath.item]
        
        cell.configure(text: coffee)
        
        return cell
    }
    
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CoffeeHeaderView.reuseId,
            for: indexPath
        ) as! CoffeeHeaderView
        
        header.configure(title: sections[indexPath.section].title)
        
        return header
    }
}


extension CoffeeGridUIKitViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        
        CGSize(width: 100, height: 100)
    }
}


final class CoffeeCell: UICollectionViewCell {
    
    static let reuseId = "CoffeeCell"
    
    
    private let emojiLabel = UILabel()
    
    private let nameLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = UIColor(named: "CoffeeCard")
        
        contentView.layer.cornerRadius = 12
        
        
        emojiLabel.font = .systemFont(ofSize: 34)
        emojiLabel.textAlignment = .center
        
        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.textAlignment = .center
        
        
        let stack = UIStackView(arrangedSubviews: [emojiLabel, nameLabel])
        
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .center
        
        
        contentView.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configure(text: String) {
        
        let parts = text.split(separator: " ")
        
        emojiLabel.text = parts.first.map(String.init)
        
        nameLabel.text = parts.dropFirst().joined(separator: " ")
    }
}


final class CoffeeHeaderView: UICollectionReusableView {
    
    static let reuseId = "CoffeeHeaderView"
    
    
    private let label = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
            
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    func configure(title: String) {
        label.text = title
    }
}
