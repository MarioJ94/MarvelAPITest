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
        self.configureGoToCharactersButton()
    }
    
    private func configureView() {
        self.view.backgroundColor = .white
    }
    
    private func configureContentView() {
        let firstScreen = Assembly.shared.provideCharacterListScreen()
        let v = UINavigationController(rootViewController: firstScreen.screen)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        v.navigationBar.compactAppearance = appearance
        v.navigationBar.standardAppearance = appearance
        v.navigationBar.scrollEdgeAppearance = appearance
        self.add(v, inContainerView: self.view, withAutolayoutMatch: true)
        v.view.backgroundColor = .clear
        self.rootView = v
    }
    
    private func configureGoToCharactersButton() {
//        let goToChar = UIButton()
//        goToChar.backgroundColor = .red
//        self.rootView.addSubview(goToChar)
//
//        goToChar.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            goToChar.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5),
//            goToChar.heightAnchor.constraint(equalToConstant: 100),
//            goToChar.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
//            goToChar.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
//        ])
//
//        goToChar.setTitle("Aasdf", for: .normal)
//        goToChar.addTarget(self, action: #selector(goToCharTapped(sender:)), for: .touchUpInside)
//
//        self.goToCharactersListButton = goToChar
    }
    
    private var subscriptions : [AnyCancellable] = []
    
    @objc
    private func goToCharTapped(sender: UIButton) {
        
    }
}



extension NSLayoutConstraint {
    func setPriority(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }
}
