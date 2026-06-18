import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = PokemonListViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.pokemons.isEmpty && viewModel.isLoading {
                    ProgressView("Загрузка...")
                } else if let errorMessage = viewModel.errorMessage, viewModel.pokemons.isEmpty {
                    VStack(spacing: 16) {
                        Text("Ошибка")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        
                        Button("Повторить") {
                            viewModel.fetchPokemons()
                        }
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.pokemons) { pokemon in
                            PokemonRowView(pokemon: pokemon)
                                .onAppear {
                                    viewModel.loadMoreIfNeeded(currentPokemon: pokemon)
                                }
                        }
                        
                        if viewModel.isLoading {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        }
                    }
                    .listStyle(.plain)
                    .refreshable {
                        viewModel.refresh()
                    }
                }
            }
            .navigationTitle("Pokémon")
            .onAppear {
                if viewModel.pokemons.isEmpty {
                    viewModel.fetchPokemons()
                }
            }
            .alert("Ошибка", isPresented: .constant(viewModel.errorMessage != nil && !viewModel.pokemons.isEmpty)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
    }
}
