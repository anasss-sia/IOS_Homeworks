import Foundation

final class PokemonService {
    
    func fetchPokemons(
        limit: Int,
        offset: Int,
        completion: ((Result<[PokemonCellModel], Error>) -> Void)?
    ) {
        let urlString = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        
        guard let url = URL(string: urlString) else {
            completion?(.failure(URLError(.badURL)))
            return
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 15
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            
            if let error {
                completion?(.failure(error))
                return
            }
            
            guard let http = response as? HTTPURLResponse,
                  (200...299).contains(http.statusCode) else {
                completion?(.failure(URLError(.badServerResponse)))
                return
            }
            
            guard let data else {
                completion?(.failure(URLError(.cannotDecodeContentData)))
                return
            }
            
            do {
                let listResponse = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                self.fetchDetails(for: listResponse.results, completion: completion)
            } catch {
                completion?(.failure(error))
            }
        }.resume()
    }
    
    private func fetchDetails(
        for items: [PokemonListItem],
        completion: ((Result<[PokemonCellModel], Error>) -> Void)?
    ) {
        let group = DispatchGroup()
        let lock = NSLock()
        
        var pokemons: [PokemonCellModel] = []
        var firstError: Error?
        
        for item in items {
            guard let url = URL(string: item.url) else { continue }
            
            group.enter()
            
            var request = URLRequest(url: url)
            request.timeoutInterval = 15
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                defer { group.leave() }
                
                if let error {
                    lock.lock()
                    if firstError == nil {
                        firstError = error
                    }
                    lock.unlock()
                    return
                }
                
                guard let http = response as? HTTPURLResponse,
                      (200...299).contains(http.statusCode),
                      let data else {
                    lock.lock()
                    if firstError == nil {
                        firstError = URLError(.badServerResponse)
                    }
                    lock.unlock()
                    return
                }
                
                do {
                    let details = try JSONDecoder().decode(PokemonDetails.self, from: data)
                    
                    let pokemon = PokemonCellModel(
                        id: details.id,
                        name: item.name.capitalized,
                        imageURL: details.sprites.frontDefault
                    )
                    
                    lock.lock()
                    pokemons.append(pokemon)
                    lock.unlock()
                } catch {
                    lock.lock()
                    if firstError == nil {
                        firstError = error
                    }
                    lock.unlock()
                }
            }.resume()
        }
        
        group.notify(queue: .global()) {
            if let firstError {
                completion?(.failure(firstError))
                return
            }
            
            let sortedPokemons = pokemons.sorted { $0.id < $1.id }
            completion?(.success(sortedPokemons))
        }
    }
}
