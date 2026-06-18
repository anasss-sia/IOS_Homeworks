import UIKit

final class SecondViewController: UIViewController {

    // MARK: - Callback
    var setTextAction: ((String) -> Void)?

    // MARK: - Subviews

    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your name"
        tf.borderStyle = .roundedRect
        tf.autocapitalizationType = .words
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()

    private let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)

        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "screen2"

        setupUI()
        doneButton.addTarget(self, action: #selector(didTapDone), for: .touchUpInside)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }

    private func setupUI() {
        view.addSubview(textField)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            doneButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.widthAnchor.constraint(equalToConstant: 140),
            doneButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Actions

    @objc private func didTapDone() {
        let name = (textField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !name.isEmpty else {
            textField.becomeFirstResponder()
            return
        }

        setTextAction?(name)
        navigationController?.popViewController(animated: true)
    }
}
