//
//  CharacterDetailsComicsInfoDataEntryView.swift
//  MarvelAPITest
//
//  Created by Mario Julià on 25/10/21.
//

import Foundation
import UIKit

protocol CharacterDetailsComicsInfoDataEntryViewDelegate : AnyObject {
    func didTapOn(model: ComicViewModel, withIndex index: Int)
}

class CharacterDetailsComicsInfoDataEntryView : UILabel {
    
    private weak var delegate : CharacterDetailsComicsInfoDataEntryViewDelegate?
    private let model : ComicViewModel
    private let index : Int
    
    init(model: ComicViewModel, index: Int, delegate: CharacterDetailsComicsInfoDataEntryViewDelegate) {
        self.model = model
        self.index = index
        self.delegate = delegate
        super.init(frame: .zero)
        self.configureEverything()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureEverything() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: model.name, attributes: underlineAttribute)
        self.attributedText = underlineAttributedString
        
        self.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(sender:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapped(sender:UITapGestureRecognizer) {
        self.delegate?.didTapOn(model: model, withIndex: index)
    }
}
