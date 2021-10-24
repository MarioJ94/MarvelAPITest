//
//  CharacterDetailsMainInfoData.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 24/10/21.
//

import Foundation
import UIKit

class CharacterDetailsMainInfoDataView : UIView {
    
    private weak var heightConstraint : NSLayoutConstraint!
    
    private let titleLabel : UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.textAlignment = .left
        return v
    }()
    
    private let descriptionLabel : UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.textAlignment = .left
        v.numberOfLines = 0
        return v
    }()
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let height = self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.height
        let width = self.titleLabel.frame.width
        return CGSize(width: width, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let height = self.sizeThatFits(CGSize(width: .max, height: .max)).height
        heightConstraint.constant = height
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureEverything()
        heightConstraint = self.heightAnchor.constraint(equalToConstant:10)
        heightConstraint.isActive = true
    }
    
    override var intrinsicContentSize: CGSize {
        let height = self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.height
        let width = self.titleLabel.frame.width
        return CGSize(width: width, height: height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureEverything() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let minTitleHeight = descriptionLabel.font.lineHeight
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: minTitleHeight)
        ])
        
        let minDescHeight = descriptionLabel.font.lineHeight
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: minDescHeight)
        ])
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
        self.setNeedsLayout()
    }
    
    func setDescription(desc: String) {
        descriptionLabel.text = desc
        self.setNeedsLayout()
    }
}
