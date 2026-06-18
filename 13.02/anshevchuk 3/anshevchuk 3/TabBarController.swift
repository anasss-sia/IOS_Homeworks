import UIKit
import SwiftUI

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabs()
    }
    
    private func configureTabs() {
        
        let swiftUIView = UIHostingController(
            rootView: NavigationStack {
                CoffeeGridSwiftUIView()
            }
        )
        
        let swiftNav = UINavigationController(rootViewController: swiftUIView)
        
        swiftNav.tabBarItem = UITabBarItem(
            title: "SwiftUI",
            image: UIImage(systemName: "square.grid.3x3.fill"),
            selectedImage: nil
        )
        
        
        let uiKitVC = CoffeeGridUIKitViewController()
        let uiKitNav = UINavigationController(rootViewController: uiKitVC)
        
        uiKitNav.tabBarItem = UITabBarItem(
            title: "UIKit",
            image: UIImage(systemName: "square.grid.3x3"),
            selectedImage: nil
        )
        
        
        viewControllers = [swiftNav, uiKitNav]
    }
}
