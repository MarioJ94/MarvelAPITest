//
//  File.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 24/10/21.
//

import Foundation

protocol CharacterDetailsScreenPresenterUseCase {
    
}

protocol CharacterDetailsScreenViewControllerProtocol: AnyObject {
    func displayErrorRetrievingData()
    func setInfo(viewModel: CharacterDetailsViewModel)
}

protocol CharacterDetailsScreenPresenterProtocol {
    func freshLoad()
}
