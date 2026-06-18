import SwiftUI


struct Slide {
    let imageName: String
}

struct ContentView: View {
    
    // MARK: - Data
    
    private let slides: [Slide] = [
        Slide(imageName: "image0"),
        Slide(imageName: "image1"),
        Slide(imageName: "image2")
    ]
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 40) {
            
            Text("gallery <3")
                .font(.system(size: 30, weight: .bold))
            
            
            Image(slides[currentIndex].imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 350)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 8)
                .padding(.horizontal, 20)
            
            
            HStack(spacing: 60) {
                
                Button {
                    showPrevious()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                
                Button {
                    showNext()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 60, height: 60)
                        .background(Color.black)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
            }
        }
        .padding(.top, 100)
    }
    
    // MARK: - Logic
    
    private func showNext() {
        currentIndex = (currentIndex + 1) % slides.count
    }
    
    private func showPrevious() {
        currentIndex = (currentIndex - 1 + slides.count) % slides.count
    }
}
