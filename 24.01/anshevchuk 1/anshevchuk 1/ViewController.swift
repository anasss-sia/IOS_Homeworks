import UIKit

class ViewController: UIViewController {

    // MARK: - Constants
    
    private enum Constant {
        enum TitleLabel {
            static let top: CGFloat = 200
            static let side: CGFloat = 16
        }
        
        enum ImageView {
            static let height: CGFloat = 400
            static let topSpacing: CGFloat = 50
            static let side: CGFloat = 16
        }
        
        enum Button {
            static let size: CGFloat = 60
            static let topSpacing: CGFloat = 50
            static let offset: CGFloat = 70
        }
    }
    
    // MARK: - Subviews
    
    private var helloLabel: UILabel = {
        let label = UILabel()
        label.text = "gallery <3"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var imageContainerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var leftButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .bold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = Constant.Button.size / 2
        button.addAction(
            UIAction { [weak self] _ in
                self?.showPrevious()
            }, for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .bold)
        let image = UIImage(systemName: "chevron.right", withConfiguration: config)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .black
        button.layer.cornerRadius = Constant.Button.size / 2
        button.addAction(
            UIAction { [weak self] _ in
                self?.showNext()
            }, for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Properties
    
    private let images: [String] = [
        "image0",
        "image1",
        "image2",
        "image3",
        "image4"
    ]
    
    private var currentIndex: Int = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        updateImage()
    }
    
    // MARK: - Methods
    
    private func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(helloLabel)
        view.addSubview(imageContainerView)
        imageContainerView.addSubview(imageView)
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        
        NSLayoutConstraint.activate([
            
            // Заголовок
            helloLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constant.TitleLabel.top),
            helloLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.TitleLabel.side),
            helloLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.TitleLabel.side),
            
            // Контейнер с тенью
            imageContainerView.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: Constant.ImageView.topSpacing),
            imageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constant.ImageView.side),
            imageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constant.ImageView.side),
            imageContainerView.heightAnchor.constraint(equalToConstant: Constant.ImageView.height),
            
            // ImageView внутри контейнера
            imageView.topAnchor.constraint(equalTo: imageContainerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainerView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainerView.bottomAnchor),
            
            // Левая кнопка
            leftButton.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: Constant.Button.topSpacing),
            leftButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -Constant.Button.offset),
            leftButton.widthAnchor.constraint(equalToConstant: Constant.Button.size),
            leftButton.heightAnchor.constraint(equalToConstant: Constant.Button.size),
            
            // Правая кнопка
            rightButton.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: Constant.Button.topSpacing),
            rightButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: Constant.Button.offset),
            rightButton.widthAnchor.constraint(equalToConstant: Constant.Button.size),
            rightButton.heightAnchor.constraint(equalToConstant: Constant.Button.size)
        ])
    }
    
    private func updateImage() {
        imageView.image = UIImage(named: images[currentIndex])
    }
    
    private func showNext() {
        currentIndex = (currentIndex + 1) % images.count
        updateImage()
    }
    
    private func showPrevious() {
        currentIndex = (currentIndex - 1 + images.count) % images.count
        updateImage()
    }
}
