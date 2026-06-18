import SwiftUI

@main
struct anshevchuk_3App: App {
    var body: some Scene {
        WindowGroup {
            UIKitHost()
        }
    }
}

struct UIKitHost: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        TabBarController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
