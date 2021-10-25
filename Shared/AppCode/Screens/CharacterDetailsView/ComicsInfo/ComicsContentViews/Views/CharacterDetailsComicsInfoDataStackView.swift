//
//  File.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 25/10/21.
//

import Foundation
import UIKit

class CharacterDetailsComicsInfoDataStackView : UIView, CharacterDetailsComicsInfoDataContentViewUseCase {
    private weak var heightConstraint : NSLayoutConstraint!
    private let presenter: CharacterDetailsComicsInfoDataContentPresenterProtocol
    private var viewModel: ComicsViewModel? = nil
    private let stackViewSpacing = 15
    
    private let stackOfComics : UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.distribution = .fillEqually
        return v
    }()
    
    init(presenter: CharacterDetailsComicsInfoDataContentPresenterProtocol) {
        self.presenter = presenter
        super.init(frame: .zero)
        self.configureEverything()
        heightConstraint = self.heightAnchor.constraint(equalToConstant:self.minimumContentHeight())
        heightConstraint.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.intrinsicContentSize.height
        heightConstraint.constant = height
    }
    
    override var intrinsicContentSize: CGSize {
        var height = self.stackOfComics.frame.origin.y + self.stackOfComics.subviews.reduce(0, { partialResult, subV in
            return partialResult + subV.intrinsicContentSize.height
        })
        height += CGFloat(max(self.stackOfComics.subviews.count,0) * stackViewSpacing)
        let width = self.frame.width
        return CGSize(width: width, height: height)
    }
    
    private func configureEverything() {
        self.addSubview(stackOfComics)
        stackOfComics.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackOfComics.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackOfComics.topAnchor.constraint(equalTo: self.topAnchor),
            stackOfComics.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackOfComics.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func minimumContentHeight() -> CGFloat {
        return 0
    }
}

extension CharacterDetailsComicsInfoDataStackView: CharacterDetailsComicsInfoDataContentStackViewProtocol {
    func setInfo(viewModel: ComicsViewModel) {
        self.viewModel = viewModel
        viewModel.comics.enumerated().forEach({ element in
            let label = CharacterDetailsComicsInfoDataEntryView(model: element.element, index: element.offset, delegate: self)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 1
            label.textColor = .cyan
            self.stackOfComics.addArrangedSubview(label)
            NSLayoutConstraint.activate([
                label.widthAnchor.constraint(equalTo: self.stackOfComics.widthAnchor)
            ])
        })
        self.stackOfComics.setNeedsLayout()
        self.setNeedsLayout()
    }
}

extension CharacterDetailsComicsInfoDataStackView: CharacterDetailsComicsInfoDataEntryViewDelegate {
    func didTapOn(model: ComicViewModel, withIndex index: Int) {
        self.presenter.didSelectViewModel(viewModel: model, atIndex: index)
    }
}
