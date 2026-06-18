import UIKit

final class FirstViewController: UIViewController {

    // MARK: - Subviews

    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let enterNameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Enter your name", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "home screen"

        setupUI()
        enterNameButton.addTarget(self, action: #selector(didTapEnterName), for: .touchUpInside)
    }

    private func setupUI() {
        view.addSubview(greetingLabel)
        view.addSubview(enterNameButton)

        NSLayoutConstraint.activate([
            enterNameButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterNameButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            enterNameButton.widthAnchor.constraint(equalToConstant: 220),
            enterNameButton.heightAnchor.constraint(equalToConstant: 50),

            greetingLabel.bottomAnchor.constraint(equalTo: enterNameButton.topAnchor, constant: -24),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            greetingLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }

    // MARK: - Actions

    @objc private func didTapEnterName() {
        let secondVC = SecondViewController()

        secondVC.setTextAction = { [weak self] name in
            guard let self = self else { return }

            self.greetingLabel.text = "Hello, \(name)!"
            self.enterNameButton.isHidden = true
        }

        navigationController?.pushViewController(secondVC, animated: true)
    }
}
