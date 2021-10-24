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
    private var currentData = CharacterListModel(theoreticalTotal: 0, charactersPages: [:])
    
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
        guard let dataPair = self.getMappedPairDataFor(pageAndIndex: pageAndIndex) else {
            return
        }
        switch dataPair.mappedData.type {
        case .error:
            self.view?.displayPopupReloadPage(page: pageAndIndex.page)
        case .success:
            guard let character = dataPair.rawData else {
                self.view?.displayPopupErrorCharacterAccess()
                return
            }
            self.attemptNavigationToCharacter(character: character)
        }
    }
    
    private func attemptNavigationToCharacter(character: Character) {
        let detailsScreen = Assembly.shared.provideCharacterDetailsScreen(withCharacter: character)
        self.view?.navigateToScreen(screen: detailsScreen.screen)
    }
    
    private func getMappedPairDataFor(pageAndIndex: (page: Int, index: Int)) -> CharacterAndMappedCharacterPair? {
        return self.currentData.charactersPages[pageAndIndex.page]?.pairs[optional: pageAndIndex.index]
    }
    
    func freshLoad() {
        let page = 0
        self.getItemsForPage(page: page) { [weak self] mappedPage in
            guard let self = self else {
                return
            }
            self.appendData(forPage: page, mappedPage: mappedPage)
            self.view?.updateListInfo(info: self.currentDataMappedToViewModel(), postReloadActions: {
                self.view?.scrollToTop(animated: false)
            })
        } onError: { [weak self] in
            guard let self = self else {
                return
            }
            self.view?.displayErrorWithRetry()
        }
    }
    
    private func currentDataMappedToViewModel() -> CharacterListViewModel {
        var charactersPagesViewModel: [Int:[CharacterListEntryViewModel]] = [:]
        self.currentData.charactersPages.forEach({ (key, value) in
            charactersPagesViewModel[key] = value.pairs.map({ $0.mappedData })
        })
        let viewModel = CharacterListViewModel(theoreticalTotal: self.currentData.theoreticalTotal, characters: charactersPagesViewModel)
        return viewModel
    }
    
    func reloadPage(page: Int) {
        var data = self.currentData.charactersPages
        data.removeValue(forKey: page)
        let newData = CharacterListModel(theoreticalTotal: self.currentData.theoreticalTotal, charactersPages: data)
        self.currentData = newData
        self.view?.updateListInfo(info: self.currentDataMappedToViewModel(), postReloadActions: nil)
        self.loadPage(page: page)
    }
    
    private func loadPage(page: Int) {
        self.getItemsForPage(page: page) { [weak self] mapResult in
            guard let self = self else {
                return
            }
            self.appendData(forPage: page, mappedPage: mapResult)
            self.view?.updateListInfo(info: self.currentDataMappedToViewModel(), postReloadActions: nil)
        } onError: { [weak self] in
            guard let self = self else {
                return
            }
            let errorData = self.buildErrorData(forPage: page)
            self.appendData(forPage: page, mappedPage: errorData)
            self.view?.updateListInfo(info: self.currentDataMappedToViewModel(), postReloadActions: nil)
        }
    }
    
    private func appendData(forPage page: Int, mappedPage: CharacterListMapResult) {
        var currentCharactersViewModels = self.currentData.charactersPages
        currentCharactersViewModels[page] = mappedPage.mappingPairs
        let newData = CharacterListModel(theoreticalTotal: mappedPage.theoreticalTotal,
                                             charactersPages: currentCharactersViewModels)
        self.currentData = newData
    }
    
    private func hasData(forPage page: Int) -> Bool {
        return self.currentData.charactersPages[page] != nil
    }
    
    private func hasOngoingRequest(forPage page: Int) -> Bool {
        return self.subscriptions[page] != nil
    }
    
    private func getItemsForPage(page: Int, onSuccess: @escaping (CharacterListMapResult) -> Void, onError: @escaping () -> Void ) {
        guard !self.hasData(forPage: page) && !self.hasOngoingRequest(forPage: page) else {
            return
        }
        
        let mapper = self.characterListViewModelMapper
        let initialParams = GetCharactersRequestParams(offset: page * self.itemsPerPage, limit: self.itemsPerPage)
        let subscription = self.getCharactersList.execute(withParams: initialParams).tryMap({ list -> CharacterListMapResult in
            let mapped = try mapper.execute(with: list)
            return mapped
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
    
    private func buildErrorData(forPage page:Int) -> CharacterListMapResult {
        let errorViewModel = CharacterListEntryViewModel.errorViewModel
        let characterAndMappedChar = CharacterAndMappedCharacterPair(rawData: nil, mappedData: errorViewModel)
        let characterPairs = [CharacterAndMappedCharacterPair](repeating: characterAndMappedChar, count: self.itemsPerPage)
        let pagePairs = CharacterListPagePairs(pairs: characterPairs)
        let mapResult = CharacterListMapResult(theoreticalTotal: self.currentData.theoreticalTotal, mappingPairs: pagePairs)
        return mapResult
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
