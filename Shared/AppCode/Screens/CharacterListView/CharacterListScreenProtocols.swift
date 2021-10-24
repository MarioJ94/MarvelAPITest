//
//  CharacterListScreenProtocols.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 22/10/21.
//

import Foundation
import UIKit

protocol CharacterListScreenPresenterUseCase {
    var viewController: UIViewController? { get }
}

protocol CharacterListScreenPresenterProtocol {
    func freshLoad()
    func reloadPage(page: Int)
    func didSelectCharacterAt(index: Int)
    func didShowItem(atIndex: Int)
    func pageAndIndexForIndex(index: Int) -> (page: Int, index: Int)
}

protocol CharacterListScreenViewControllerProtocol: AnyObject {
    var viewController: UIViewController { get }
    func updateListInfo(info: CharacterListViewModel, postReloadActions: (() -> Void)?)
    func scrollToTop(animated: Bool)
    func displayErrorWithRetry()
    func displayPopupReloadPage(page: Int)
}
