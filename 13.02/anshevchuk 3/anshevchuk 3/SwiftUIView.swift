import SwiftUI

struct CoffeeSection: Identifiable {
    let id = UUID()
    let title: String
    let items: [String]
}

struct CoffeeGridSwiftUIView: View {
    
    private let sections: [CoffeeSection] = [
        CoffeeSection(
            title: "Hot",
            items: ["☕️ Espresso", "🥛 Latte", "🍫 Mocha", "🍵 Cappuccino", "🫖 Americano"]
        ),
        
        CoffeeSection(
            title: "Cold",
            items: ["🧊 Iced Latte", "🧋 Cold Brew", "🍹 Frappé", "🥤 Iced Mocha", "🧊 Iced Americano"]
        )
    ]
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    
    var body: some View {
        
        ScrollView {
            
            LazyVStack(alignment: .leading, spacing: 16) {
                
                ForEach(sections) { section in
                    
                    Text(section.title)
                        .font(.headline)
                        .padding(.horizontal, 16)
                    
                    
                    LazyVGrid(columns: columns, spacing: 12) {
                        
                        ForEach(section.items, id: \.self) { coffee in
                            
                            CoffeeCardView(text: coffee)
                            
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.top, 16)
        }
        .background(Color("CoffeeBackground").ignoresSafeArea())
    }
}

private struct CoffeeCardView: View {
    
    let text: String
    
    var body: some View {
        
        let parts = text.split(separator: " ")
        let emoji = parts.first.map(String.init) ?? ""
        let name = parts.dropFirst().joined(separator: " ")
        
        VStack(spacing: 6) {
            
            Text(emoji)
                .font(.system(size: 34))
            
            Text(name)
                .font(.system(size: 12))
        }
        .frame(width: 100, height: 100)
        .background(Color("CoffeeCard"))
        .cornerRadius(12)
    }
}
