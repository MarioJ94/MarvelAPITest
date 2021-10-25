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
        if currentDeviceType() == .phone {
            v.font = .systemFont(ofSize: 25)
        } else {
            v.font = .systemFont(ofSize: 35)
        }
        return v
    }()
    
    private let descriptionLabel : UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.textAlignment = .left
        v.numberOfLines = 0
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
        let height = self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.height
        let width = self.titleLabel.frame.width
        return CGSize(width: width, height: height)
    }
    
    private func configureEverything() {
        self.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            descriptionLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 15),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
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
    
    private func minimumHeight() -> CGFloat {
        return 0
    }
}
