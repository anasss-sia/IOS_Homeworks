import Foundation
import Combine

final class PokemonListViewModel: ObservableObject {
    
    @Published var pokemons: [PokemonCellModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = PokemonService()
    
    private let limit = 10
    private var offset = 0
    private var canLoadMore = true
    
    func fetchPokemons() {
        guard !isLoading, canLoadMore else { return }
        
        isLoading = true
        errorMessage = nil
        
        service.fetchPokemons(limit: limit, offset: offset) { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                self.isLoading = false
                
                switch result {
                case .success(let newPokemons):
                    if newPokemons.isEmpty {
                        self.canLoadMore = false
                    } else {
                        self.pokemons.append(contentsOf: newPokemons)
                        self.offset += self.limit
                    }
                    
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func loadMoreIfNeeded(currentPokemon: PokemonCellModel) {
        guard let lastPokemon = pokemons.last else { return }
        
        if currentPokemon.id == lastPokemon.id {
            fetchPokemons()
        }
    }
    
    func refresh() {
        pokemons = []
        offset = 0
        canLoadMore = true
        errorMessage = nil
        fetchPokemons()
    }
}
