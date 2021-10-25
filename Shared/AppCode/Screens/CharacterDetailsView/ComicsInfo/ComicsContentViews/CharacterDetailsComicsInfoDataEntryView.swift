//
//  CharacterDetailsComicsInfoDataEntryView.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 25/10/21.
//

import Foundation
import UIKit

class CharacterDetailsComicsInfoDataEntryView : UIView {
    
    private weak var heightConstraint : NSLayoutConstraint!
    
    private let title : UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.textAlignment = .left
        return v
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureEverything()
        heightConstraint = self.heightAnchor.constraint(equalToConstant:self.minimumHeight())
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
        let height = self.title.frame.height
        let width = self.title.frame.width
        return CGSize(width: width, height: height)
    }
    
    private func configureEverything() {
        self.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        let minTitleHeight = title.font.lineHeight
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            title.heightAnchor.constraint(equalToConstant: minTitleHeight)
        ])
    }
    
    private func minimumHeight() -> CGFloat {
        return 0
    }
}
