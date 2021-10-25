//
//  CharacterDetailsComicsInfoDataContentProtocols.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 25/10/21.
//

import Foundation
import UIKit

protocol CharacterDetailsComicsInfoDataContentViewUseCase: UIView {
    
}

protocol CharacterDetailsComicsInfoDataContentStackViewProtocol: AnyObject {
    func setInfo(viewModel: ComicsViewModel)
}

protocol CharacterDetailsComicsInfoDataContentPresenterProtocol {
    func didSelectViewModel(viewModel: ComicViewModel, atIndex index: Int)
}

protocol CharacterDetailsComicsInfoDataContentPresenterDelegate: AnyObject {
    func didSelectModel(comic: ComicSummary)
}
