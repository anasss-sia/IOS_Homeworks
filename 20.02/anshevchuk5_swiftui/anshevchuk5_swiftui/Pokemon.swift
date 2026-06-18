import Foundation

struct PokemonListResponse: Decodable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Decodable {
    let name: String
    let url: String
}

struct PokemonDetails: Decodable {
    let id: Int
    let sprites: PokemonSprites
}

struct PokemonSprites: Decodable {
    let frontDefault: String?
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct PokemonCellModel: Identifiable, Equatable {
    let id: Int
    let name: String
    let imageURL: String?
}
