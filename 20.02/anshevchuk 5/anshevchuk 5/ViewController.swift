import UIKit

final class ViewController: UIViewController {
    
    private let tableView = UITableView()
    private var pokemons: [PokemonCellModel] = []
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var isLoading = false
    private var limit = 20
    private var offset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        title = "Pokémon"
        view.backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            PokemonTableViewCell.self,
            forCellReuseIdentifier: PokemonTableViewCell.identifier
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 92
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func fetchData() {
        guard !isLoading else { return }
        isLoading = true
        
        if pokemons.isEmpty {
            activityIndicator.startAnimating()
        }
        
        PokemonService.fetchPokemons(limit: limit, offset: offset) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                self.activityIndicator.stopAnimating()
                self.isLoading = false
                
                switch result {
                case .success(let newPokemons):
                    self.pokemons.append(contentsOf: newPokemons)
                    self.offset += self.limit
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print("Loading error:", error.localizedDescription)
                    self.showErrorAlert(message: "Не удалось загрузить покемонов.")
                }
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Ошибка",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemons.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: PokemonTableViewCell.identifier,
            for: indexPath
        ) as? PokemonTableViewCell else {
            return UITableViewCell()
        }
        
        let pokemon = pokemons[indexPath.row]
        cell.configure(with: pokemon)
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElementIndex = pokemons.count - 1
        
        if indexPath.row == lastElementIndex {
            fetchData()
        }
    }
}
