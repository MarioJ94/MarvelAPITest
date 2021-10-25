//
//  Main.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 19/10/21.
//

import Foundation
import UIKit
import Combine

class Main : UIViewController {
    private var rootView: UINavigationController!
    private var goToCharactersListButton: UIButton! = nil
    
    class func initializer() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "Main")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureContentView()
    }
    
    private func configureView() {
        self.view.backgroundColor = .white
    }
    
    private func configureContentView() {
        let firstScreen = Assembly.shared.provideCharacterListScreen()
        let v = UINavigationController(rootViewController: firstScreen.screen)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .lightGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        v.navigationBar.compactAppearance = appearance
        v.navigationBar.standardAppearance = appearance
        v.navigationBar.scrollEdgeAppearance = appearance
        
        self.add(v, inContainerView: self.view, withAutolayoutMatch: true)
        v.view.backgroundColor = .clear
        self.rootView = v
    }
}



extension NSLayoutConstraint {
    func setPriority(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
