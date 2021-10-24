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

    private let titleLabel : UILabel = {
        let v = UILabel()
        v.textColor = .black
        v.textAlignment = .left
        return v
    }()
    
    private let descriptionLabel : UILabel = {
        let v = UILabel()
        v.textColor = .black
        v.textAlignment = .left
        return v
    }()
    
    private weak var scrollView: UIScrollView!
    private weak var stackView: UIStackView!

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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isMovingToParent {
            self.scrollView.layoutIfNeeded()
        }
        self.presenter.freshLoad()
    }
    
    private func configureUI() {
        self.view.backgroundColor = .black
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
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
            backgroundImage.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.5)
        ])
        
        self.backgroundImage = backgroundImage
        
        let emptyView = CharacterDetailsMainInfoDataView()
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(emptyView)
        NSLayoutConstraint.activate([
            emptyView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            emptyView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        ])
        self.dataView = emptyView
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
            print("found error \(err != nil)")
        }
    }
}

extension CharacterDetailsScreenViewController: CharacterDetailsScreenViewControllerProtocol {
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
    }
}
