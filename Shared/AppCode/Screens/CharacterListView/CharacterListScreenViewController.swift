//
//  CharacterListScreenViewController.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 22/10/21.
//

import Foundation
import UIKit

class CharacterListScreenViewController: UIViewController {
    private var presenter : CharacterListScreenPresenterProtocol?
    private var model : CharacterListViewModel?
    private var tableView : UITableView!
    private let cellId = "CharacterListEntryCell"
    private var errorView : UIView?
    private var spinner: UIActivityIndicatorView!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureTableView()
        self.configureSpinner()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        self.modifyContentInset(newContentInset: self.view.safeAreaInsets)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.freshLoad()
    }
    
    func setPresenter(presenter: CharacterListScreenPresenterProtocol) {
        self.presenter = presenter
    }
    
    private func modifyContentInset(newContentInset: UIEdgeInsets) {
        guard let tableV = self.tableView else {
            return
        }
        tableV.contentInset = newContentInset
    }
    
    private func configureTableView() {
        let tableV = UITableView(frame: .zero, style: .plain)
        
        self.view.addSubview(tableV)
        tableV.translatesAutoresizingMaskIntoConstraints = true
        tableV.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableV.frame = self.view.bounds
        tableV.delegate = self
        tableV.dataSource = self
        tableV.contentInsetAdjustmentBehavior = .never
        tableV.backgroundColor = .clear
        tableV.insetsLayoutMarginsFromSafeArea = false
        tableV.register(CharacterListEntryCell.self,
                        forCellReuseIdentifier: self.cellId)
        tableV.separatorInset = .zero
        self.tableView = tableV
    }
    
    private func configureSpinner() {
        let newSp = UIActivityIndicatorView(style: .large)
        newSp.color = .white
        newSp.hidesWhenStopped = true
        self.spinner = newSp
    }
    
    private func removeErrorView() {
        self.errorView?.removeFromSuperview()
        self.errorView = nil
    }
    
    private func showTableView() {
        self.tableView.isHidden = false
        self.removeErrorView()
        self.spinner.stopAnimating()
    }
    
    private func hideTableView() {
        self.tableView.isHidden = true
    }
    
    private func showSpinner() {
        self.removeErrorView()
        self.hideTableView()
        self.spinner.startAnimating()
    }
    
    private func hideSpinner() {
        self.spinner.stopAnimating()
    }
}

extension CharacterListScreenViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("Current \(scrollView.contentOffset)")
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.presenter?.didSelectCharacterAt(index: indexPath.row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.theoreticalTotal ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.presenter?.didShowItem(atIndex: indexPath.row)
    }
}

extension CharacterListScreenViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
    }
}

extension CharacterListScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
        guard let entryCell = cell as? CharacterListEntryCell else {
            return cell
        }
        entryCell.resetCell()
        entryCell.selectionStyle = .blue
        entryCell.preservesSuperviewLayoutMargins = false
        entryCell.separatorInset = .zero
        entryCell.layoutMargins = .zero
        
        guard let rowLoc = self.presenter?.pageAndIndexForIndex(index: indexPath.row) else {
            return entryCell
        }
        
        guard let rowViewModel = self.model?.charactersPages[rowLoc.page]?.characters[optional: rowLoc.index] else {
            entryCell.setLoading()
            return entryCell
        }
        entryCell.setInfo(model: rowViewModel)
        return entryCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension CharacterListScreenViewController: CharacterListScreenViewControllerProtocol {
    var viewController: UIViewController {
        return self
    }
    
    func updateListInfo(info: CharacterListViewModel, postReloadActions: (() -> Void)?) {
        self.showTableView()
        self.model = info
        self.tableView.reloadData()
        postReloadActions?()
    }
    
    func scrollToTop(animated: Bool) {
        let top = CGPoint(x: 0, y: -self.tableView.contentInset.top)
        self.tableView.setContentOffset(top, animated: animated)
    }
    
    func displayErrorWithRetry() {
        self.tableView.isHidden = true
        self.removeErrorView()
        let newErrorView = UIView()
        newErrorView.translatesAutoresizingMaskIntoConstraints = true
        newErrorView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newErrorView.insetsLayoutMarginsFromSafeArea = true
        newErrorView.frame = self.view.bounds
        newErrorView.backgroundColor = .red.withAlphaComponent(0.5)
        self.view.addSubview(newErrorView)
        self.errorView = newErrorView
        
        let button = UIButton()
        newErrorView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Retry", for: .normal)
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: newErrorView.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: newErrorView.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func displayPopupReloadPage(page: Int) {
        let popup = UIAlertController(title: "Reload", message: "Do you want to reload this content of page \(page)?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] act in
            self?.presenter?.reloadPage(page: page)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        popup.addAction(okAction)
        popup.addAction(cancelAction)
        self.present(popup, animated: true, completion: nil)
    }
    
    @objc func didTapRetry() {
        self.removeErrorView()
        self.showSpinner()
        self.presenter?.freshLoad()
    }
}

extension Collection {
    subscript(optional i: Index) -> Iterator.Element?{
        return self.indices.contains(i) ? self[i] : nil
    }
}
