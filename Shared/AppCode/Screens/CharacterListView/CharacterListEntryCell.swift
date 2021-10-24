//
//  CharacterListEntryCell.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 22/10/21.
//

import Foundation
import UIKit
import SDWebImage

class CharacterListEntryCell : UITableViewCell {
    private let label : UILabel = {
        let v = UILabel()
        v.textColor = .black
        v.textAlignment = .left
        return v
    }()
    
    private let thumbnail : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        return v
    }()
    
    private let cellDetailsStack : UIStackView = {
        let v = UIStackView()
        v.spacing = 10
        v.axis = .horizontal
        v.alignment = .center
        return v
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func configureViews() {
        self.configureBackground()
        self.configureDetailsViews()
    }
    
    private func configureBackground() {
        self.backgroundColor = .clear
    }
    
    private func configureDetailsViews() {
        // stack
        self.addSubview(cellDetailsStack)
        cellDetailsStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellDetailsStack.topAnchor.constraint(equalTo: self.topAnchor),
            cellDetailsStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            cellDetailsStack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellDetailsStack.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10)
        ])
        
        // thumbnail
        cellDetailsStack.addArrangedSubview(thumbnail)
        NSLayoutConstraint.activate([
            thumbnail.heightAnchor.constraint(equalTo: thumbnail.widthAnchor, multiplier: 1.0),
            thumbnail.heightAnchor.constraint(lessThanOrEqualTo: cellDetailsStack.heightAnchor, multiplier: 0.8),
            thumbnail.heightAnchor.constraint(equalTo: cellDetailsStack.heightAnchor, multiplier: 0.8).setPriority(priority: .defaultHigh),
            thumbnail.widthAnchor.constraint(lessThanOrEqualTo: cellDetailsStack.widthAnchor, multiplier: 0.25)
        ])
        
        // label
        cellDetailsStack.addArrangedSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: thumbnail.topAnchor),
            label.bottomAnchor.constraint(equalTo: thumbnail.bottomAnchor)
        ])
        
    }
    
    func resetCell() {
        self.backgroundColor = .clear
        self.label.text = ""
        self.thumbnail.sd_cancelCurrentImageLoad()
        self.thumbnail.image = nil
    }
    
    func setInfo(model: CharacterListEntryViewModel) {
        self.label.text = model.name
        self.setImage(url: model.thumbnail)
        if model.type == .error {
            self.backgroundColor = .red
        }
    }
    
    func setLoading() {
        self.label.text = "Loading"
    }
    
    private func setImage(url: String?) {
        guard let url = url else {
            return
        }
        let urlToUse = URL(string: url)
        let placeholder = UIImage().withTintColor(.red)
        self.thumbnail.sd_setImage(with: urlToUse, placeholderImage: placeholder, options: [.refreshCached], context: nil, progress: nil) { image, err, typ, usedUrl in
            self.thumbnail.image = image
        }
    }
}
