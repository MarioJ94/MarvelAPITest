//
//  CharacterDetailsComicsInfoDataEmptyView.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 25/10/21.
//

import Foundation
import UIKit

class CharacterDetailsComicsInfoDataEmptyView: UIView, CharacterDetailsComicsInfoDataContentViewUseCase {
    private weak var heightConstraint : NSLayoutConstraint!
    private let messageLabel : UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.textColor = .white
        v.text = "No results"
        v.numberOfLines = 1
        return v
    }()
    
    init() {
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
        let height = self.messageLabel.intrinsicContentSize.height + 40
        let width = self.frame.width
        return CGSize(width: width, height: height)
    }
    
    private func configureEverything() {
        self.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            messageLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20)
        ])
    }
    
    private func minimumContentHeight() -> CGFloat {
        return self.messageLabel.font.lineHeight
    }
}
