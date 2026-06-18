import UIKit

final class ViewController: UIViewController {
    
    // MARK: - Constants
    
    private enum Constant {
        
        enum PreviewView {
            static let height: CGFloat = 220
            static let cornerRadius: CGFloat = 20
            static let topInset: CGFloat = 16
            static let horizontalInset: CGFloat = 16
        }
        
        enum TableView {
            static let topInset: CGFloat = 24
            static let rowHeight: CGFloat = 60
            static let spacing: CGFloat = 12
            static let horizontalInset: CGFloat = 16
            static let cellCornerRadius: CGFloat = 12
        }
    }
    
    // MARK: - Data
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemGreen,
        .systemOrange
    ]
    
    private let rowTitles: [String] = [
        "Розовый цвет",
        "Синий цвет",
        "Зеленый цвет",
        "Оранжевый цвет"
    ]
    
    // MARK: - Subviews
    
    private let previewView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = Constant.PreviewView.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Выберите строку"
        label.font = .systemFont(ofSize: 26, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = Constant.TableView.rowHeight
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
        setupTableView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "UITableView"
    }
    
    private func setupHierarchy() {
        view.addSubview(previewView)
        previewView.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constant.PreviewView.topInset
            ),
            previewView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constant.PreviewView.horizontalInset
            ),
            previewView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constant.PreviewView.horizontalInset
            ),
            previewView.heightAnchor.constraint(
                equalToConstant: Constant.PreviewView.height
            ),
            
            titleLabel.centerXAnchor.constraint(equalTo: previewView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: previewView.centerYAnchor),
            
            tableView.topAnchor.constraint(
                equalTo: previewView.bottomAnchor,
                constant: Constant.TableView.topInset
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constant.TableView.horizontalInset
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constant.TableView.horizontalInset
            ),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Actions
    
    private func updateColor(_ color: UIColor) {
        DispatchQueue.main.async { [weak self] in
            guard let self else {
                return
            }
            
            UIView.animate(withDuration: 0.25) { [weak self] in
                guard let self else {
                    return
                }
                
                self.previewView.backgroundColor = color
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        rowTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = rowTitles[indexPath.section]
        content.textProperties.alignment = .center
        content.textProperties.font = .systemFont(ofSize: 18, weight: .medium)
        
        cell.contentConfiguration = content
        cell.accessoryType = .none
        cell.backgroundColor = .systemGray6
        cell.layer.cornerRadius = Constant.TableView.cellCornerRadius
        cell.layer.masksToBounds = true
        cell.selectionStyle = .default
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedColor = colors[indexPath.section]
        updateColor(selectedColor)
        
        DispatchQueue.main.async { [weak tableView] in
            tableView?.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        Constant.TableView.spacing
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
}
