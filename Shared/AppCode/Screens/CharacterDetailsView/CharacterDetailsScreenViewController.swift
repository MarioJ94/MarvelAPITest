//
//  CharacterDetailsScreenViewController.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 24/10/21.
//

import Foundation
import UIKit

class CharacterDetailsScreenViewController: UIViewController {
    private var presenter: CharacterDetailsScreenPresenterProtocol
    
    private weak var backgroundImage : UIImageView?
    private weak var dataView: CharacterDetailsMainInfoDataView?
    private weak var comicsView: CharacterDetailsComicsInfoDataView?
    private weak var scrollView: UIScrollView!
    private weak var stackView: UIStackView!
    private weak var spinner: UIActivityIndicatorView!
    
    init(presenter: CharacterDetailsScreenPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.configureScrollView()
        self.configureSpinner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isMovingToParent {
            self.onlyShowSpinner()
            self.scrollView.layoutIfNeeded()
            self.presenter.freshLoad()
        }
    }
    
    private func configureUI() {
        self.view.backgroundColor = .black
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.stackView.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let gradientMaskLayer = CAGradientLayer()
        gradientMaskLayer.frame = backgroundImage!.bounds
        gradientMaskLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientMaskLayer.locations = [0, 1]
        backgroundImage!.layer.mask = gradientMaskLayer
    }
    
    private func configureScrollView() {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.scrollView = scrollView
        
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        self.stackView = stackView
        
        let backgroundImage = UIImageView()
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        stackView.addArrangedSubview(backgroundImage)
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.5)
        ])
        
        self.backgroundImage = backgroundImage
        
        let mainInfo = CharacterDetailsMainInfoDataView()
        mainInfo.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(mainInfo)
        NSLayoutConstraint.activate([
            mainInfo.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            mainInfo.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        ])
        self.dataView = mainInfo
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(spacer)
        NSLayoutConstraint.activate([
            spacer.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            spacer.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            spacer.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        let extrainfo = CharacterDetailsComicsInfoDataView()
        extrainfo.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(extrainfo)
        NSLayoutConstraint.activate([
            extrainfo.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            extrainfo.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        ])
        self.comicsView = extrainfo
    }
    
    private func configureSpinner() {
        let newSp = UIActivityIndicatorView(style: .large)
        self.view.addSubview(newSp)
        newSp.color = .white
        newSp.hidesWhenStopped = true
        newSp.translatesAutoresizingMaskIntoConstraints = true
        newSp.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        newSp.frame = self.view.bounds
        self.spinner = newSp
    }
    
    private func resetBackgroundImage() {
        self.backgroundImage?.sd_cancelCurrentImageLoad()
        self.backgroundImage?.image = nil
    }
    
    private func setBackgroundImageURL(urlString: String?) {
        guard let urlString = urlString else {
            return
        }
        let url = URL(string: urlString)
        self.backgroundImage?.sd_setImage(with: url, placeholderImage: nil, options: [.refreshCached], context: nil, progress: nil) { image, err, type, url in
            if (err != nil) {
                print("error downloading image")
            }
        }
    }
}

enum CharacterDetailsScreenDataFechError {
    case errorFetchingData
    case errorParsingData
}

extension CharacterDetailsScreenViewController: CharacterDetailsScreenViewControllerProtocol {
    func displayError(errorType: CharacterDetailsScreenDataFechError) {
        self.hideSpinner()
        self.hideDetails()
        switch errorType {
        case .errorFetchingData:
            self.displayErrorFetchingData()
        case .errorParsingData:
            self.displayErrorParsingData()
        }
    }
    
    func displayErrorRetrievingData() {
        let popup = UIAlertController(title: "Error", message: "There was an error with the data", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] act in
            self?.navigationController?.popViewController(animated: true)
        }
        popup.addAction(okAction)
        self.present(popup, animated: true, completion: nil)
    }
    
    func setInfo(viewModel: CharacterDetailsViewModel) {
        self.resetBackgroundImage()
        self.setBackgroundImageURL(urlString: viewModel.thumbnail)
        self.dataView?.setTitle(title: viewModel.name)
        self.dataView?.setDescription(desc: viewModel.description)
        self.comicsView?.setComics(comics: viewModel.comicsCombinedModel, delegate: self.presenter.comicsInteractionDelegate)
        self.onlyShowDetails()
    }
}

extension CharacterDetailsScreenViewController {
    private func displayErrorFetchingData() {
        let popup = UIAlertController(title: "Error", message: "Data request error", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] act in
            self?.navigationController?.popViewController(animated: true)
        }
        popup.addAction(okAction)
        self.present(popup, animated: true, completion: nil)
    }
    
    private func displayErrorParsingData() {
        let popup = UIAlertController(title: "Error", message: "Received data can't be displayed", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] act in
            self?.navigationController?.popViewController(animated: true)
        }
        popup.addAction(okAction)
        self.present(popup, animated: true, completion: nil)
    }
    
    private func showDetails() {
        self.scrollView.isHidden = false
    }
    
    private func onlyShowDetails() {
        self.showDetails()
        self.hideSpinner()
    }
    
    private func hideDetails() {
        self.scrollView.isHidden = true
    }
    
    private func showSpinner() {
        self.spinner.startAnimating()
    }
    
    private func onlyShowSpinner() {
        self.hideDetails()
        self.showSpinner()
    }
    
    private func hideSpinner() {
        self.spinner.stopAnimating()
    }
}
