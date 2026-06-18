import SwiftUI

struct PokemonRowView: View {
    let pokemon: PokemonCellModel
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: pokemon.imageURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 64, height: 64)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(pokemon.name)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("ID: \(pokemon.id)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
