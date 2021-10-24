//
//  CharacterDetailsScreenViewController.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 24/10/21.
//

import Foundation
import UIKit

class CharacterDetailsScreenViewController: UIViewController {
    private var presenter: CharacterDetailsScreenPresenterUseCase
    
    init(presenter: CharacterDetailsScreenPresenterUseCase) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .black
    }
}

extension CharacterDetailsScreenViewController: CharacterDetailsScreenViewControllerProtocol {

}
