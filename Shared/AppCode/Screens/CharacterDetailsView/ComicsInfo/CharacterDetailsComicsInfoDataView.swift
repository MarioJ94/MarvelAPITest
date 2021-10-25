//
//  CharacterDetailsExtraInfoDataView.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 25/10/21.
//

import Foundation
import UIKit

class CharacterDetailsComicsInfoDataView : UIView {
    
    private weak var heightConstraint : NSLayoutConstraint!
    private let contentSpacing : CGFloat = 10
    
    private let comicsSectionTitle : UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.textAlignment = .left
        v.font = UIFont.systemFont(ofSize: 25)
        v.text = "Comics"
        v.numberOfLines = 1
        return v
    }()
    
    private weak var comicsContents : CharacterDetailsComicsInfoDataContentViewUseCase!
    
    private let stackOfComics : UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.distribution = .fill
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureEverything()
        heightConstraint = self.heightAnchor.constraint(equalToConstant:self.intrinsicContentSize.height)
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
        let width = self.comicsSectionTitle.frame.width
        var totalHeight : CGFloat = comicsSectionTitle.font.lineHeight + contentSpacing
        if let comicsContents = self.comicsContents {
            totalHeight += comicsContents.intrinsicContentSize.height
        } else {
            totalHeight += minimumContentHeight()
        }
        return CGSize(width: width, height: totalHeight)
    }
    
    private func configureEverything() {
        self.addSubview(comicsSectionTitle)
        comicsSectionTitle.translatesAutoresizingMaskIntoConstraints = false
        let minTitleHeight = comicsSectionTitle.font.lineHeight
        NSLayoutConstraint.activate([
            comicsSectionTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            comicsSectionTitle.topAnchor.constraint(equalTo: self.topAnchor),
            comicsSectionTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            comicsSectionTitle.heightAnchor.constraint(greaterThanOrEqualToConstant: minTitleHeight)
        ])
    }
    
    func setComics(comics: ComicsCombinedModels, delegate: CharacterDetailsComicsInfoDataContentPresenterDelegate) {
        let comicsView : CharacterDetailsComicsInfoDataContentViewUseCase
        if !comics.comics.isEmpty {
            comicsView = Assembly.shared.provideComicsInfoContentView(combinedModels: comics, delegate: delegate)
        } else {
            comicsView = Assembly.shared.provideEmptyComicsInfoContentView()
        }
        comicsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(comicsView)
        NSLayoutConstraint.activate([
            comicsView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            comicsView.topAnchor.constraint(equalTo: self.comicsSectionTitle.bottomAnchor, constant: contentSpacing),
            comicsView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            comicsView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        self.comicsContents = comicsView
        self.setNeedsLayout()
    }
    
    private func minimumContentHeight() -> CGFloat {
        return 0
    }
}
