//
//  CharacterListScreenPresenter.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 22/10/21.
//

import Foundation
import UIKit
import Combine

class CharacterListScreenPresenter {
    private weak var view: CharacterListScreenViewControllerProtocol?
    private let getCharactersList: GetCharacterListUseCase
    private let characterListViewModelMapper: CharacterListViewModelMapperUseCase
    
    private var subscriptions: [Int:AnyCancellable] = [:]
    private let itemsPerPage : Int
    private var currentData : CharacterListViewModel = CharacterListViewModel(theoreticalTotal: 0, charactersPages: [:])
    
    init(view: CharacterListScreenViewControllerProtocol,
         getCharactersList: GetCharacterListUseCase,
         characterListViewModelMapper: CharacterListViewModelMapperUseCase,
         itemsPerPage: Int) {
        self.view = view
        self.getCharactersList = getCharactersList
        self.characterListViewModelMapper = characterListViewModelMapper
        self.itemsPerPage = itemsPerPage
    }
}

extension CharacterListScreenPresenter : CharacterListScreenPresenterProtocol {
    func pageAndIndexForIndex(index: Int) -> (page: Int, index: Int) {
        let page = index / self.itemsPerPage
        let index = index % self.itemsPerPage
        return (page, index)
    }
    
    func didSelectCharacterAt(index: Int) {
        let pageAndIndex = self.pageAndIndexForIndex(index: index)
        guard let character = self.currentData.charactersPages[pageAndIndex.page]?.characters[pageAndIndex.index] else {
            print("LOADING")
            return
        }
        switch character.type {
        case .error:
            self.view?.displayPopupReloadPage(page: pageAndIndex.page)
        case .success:
            print("SUCCESS")
        }
    }
    
    func freshLoad() {
        let page = 0
        self.getItemsForPage(page: page) { [weak self] mappedPage in
            guard let self = self else {
                return
            }
            self.appendData(forPage: page, mappedPage: mappedPage)
            self.view?.updateListInfo(info: self.currentData, postReloadActions: {
                self.view?.scrollToTop(animated: false)
            })
        } onError: { [weak self] in
            guard let self = self else {
                return
            }
            self.view?.displayErrorWithRetry()
        }
    }
    
    func reloadPage(page: Int) {
        var data = self.currentData.charactersPages
        data.removeValue(forKey: page)
        let newData = CharacterListViewModel(theoreticalTotal: self.currentData.theoreticalTotal, charactersPages: data)
        self.currentData = newData
        self.view?.updateListInfo(info: self.currentData, postReloadActions: nil)
        self.loadPage(page: page)
    }
    
    private func loadPage(page: Int) {
        self.getItemsForPage(page: page) { [weak self] mappedPage in
            guard let self = self else {
                return
            }
            self.appendData(forPage: page, mappedPage: mappedPage)
            self.view?.updateListInfo(info: self.currentData, postReloadActions: nil)
        } onError: { [weak self] in
            guard let self = self else {
                return
            }
            let errorData = self.buildErrorData(forPage: page)
            self.appendData(forPage: page, mappedPage: errorData)
            self.view?.updateListInfo(info: self.currentData, postReloadActions: nil)
        }
    }
    
    private func appendData(forPage page: Int, mappedPage: CharacterListMapped) {
        var currentCharactersViewModels = self.currentData.charactersPages
        currentCharactersViewModels[page] = mappedPage.charactersPage
        let newData = CharacterListViewModel(theoreticalTotal: mappedPage.theoreticalTotal,
                                             charactersPages: currentCharactersViewModels)
        self.currentData = newData
    }
    
    private func hasData(forPage page: Int) -> Bool {
        return self.currentData.charactersPages[page] != nil
    }
    
    private func hasOngoingRequest(forPage page: Int) -> Bool {
        return self.subscriptions[page] != nil
    }
    
    private func getItemsForPage(page: Int, onSuccess: @escaping (CharacterListMapped) -> Void, onError: @escaping () -> Void ) {
        guard !self.hasData(forPage: page) && !self.hasOngoingRequest(forPage: page) else {
            return
        }
        
        let mapper = self.characterListViewModelMapper
        let initialParams = GetCharactersRequestParams(offset: page * self.itemsPerPage, limit: self.itemsPerPage)
        let subscription = self.getCharactersList.execute(withParams: initialParams).tryMap({ list -> CharacterListMapped in
            return try mapper.execute(with: list)
        }).receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] compl in
                guard let self = self else {
                    return
                }
                self.subscriptions.removeValue(forKey: page)
                switch compl {
                case .failure(let error):
                    onError()
                    print(error)
                case .finished:
                    print("getCharactersList.execute success")
                }
            }, receiveValue: { viewModel in
                onSuccess(viewModel)
            })
        self.subscriptions[page] = subscription
    }
    
    private func buildErrorData(forPage page:Int) -> CharacterListMapped {
        let errorVideModel = CharacterListEntryViewModel.errorViewModel
        let characterList = [CharacterListEntryViewModel](repeating: errorVideModel, count: self.itemsPerPage)
        let page = CharacterListPage(startingIndex: page*self.itemsPerPage, characters: characterList)
        let errorData = CharacterListMapped(theoreticalTotal: self.currentData.theoreticalTotal, charactersPage: page)
        return errorData
    }
    
    func didShowItem(atIndex index: Int) {
        let page = self.pageAndIndexForIndex(index: index).page
        self.loadPage(page: page)
    }
}

extension CharacterListScreenPresenter: CharacterListScreenPresenterUseCase {
    var viewController: UIViewController? {
        self.view?.viewController
    }
}
