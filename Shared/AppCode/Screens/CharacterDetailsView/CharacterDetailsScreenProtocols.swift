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
    func displayError(errorType: CharacterDetailsScreenDataFechError)
    func setInfo(viewModel: CharacterDetailsViewModel)
}

protocol CharacterDetailsScreenPresenterProtocol {
    var comicsInteractionDelegate: CharacterDetailsComicsInfoDataContentPresenterDelegate { get }
    func freshLoad()
}
