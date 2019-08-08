//
//  ListCell.swift
//  LunchTyme
//
//  Created by Yu Zhang on 7/30/19.
//  Copyright © 2019 Yu Zhang. All rights reserved.
//

import UIKit
class ListCell: UICollectionViewCell {
    
    let textColor: UIColor = UIColor(red: 255, green: 255, blue: 255)
    let nameFont: UIFont = UIFont.init(name: "AvenirNext-DemiBold", size: 16)!
    let categoryFont: UIFont = UIFont.init(name: "AvenirNext-Regular", size: 12)!
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.clipsToBounds = true
        return view
    }()
    
    let nameLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    let categoryLabel: UILabel = {
        let view = UILabel()
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        nameLabel.textColor = textColor
        nameLabel.font = nameFont
        nameLabel.textAlignment = .center
        categoryLabel.textColor = textColor
        categoryLabel.font = categoryFont
        categoryLabel.textAlignment = .center
        addSubview(imageView)
        imageView.addSubview(nameLabel)
        imageView.addSubview(categoryLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[v]-|", options: [], metrics: nil, views: ["v" : imageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v]-|", options: [], metrics: nil, views: ["v" : imageView]))
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let nameLabelConstraints = [NSLayoutConstraint(item: nameLabel, attribute: .leading, relatedBy: .equal, toItem: imageView, attribute: .leading, multiplier: 1.0, constant: 12), NSLayoutConstraint(item: nameLabel, attribute: .bottom, relatedBy: .equal, toItem: categoryLabel, attribute: .top, multiplier: 1.0, constant: -6)]
        addConstraints(nameLabelConstraints)
        
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        let categoryLabelConstraints = [NSLayoutConstraint(item: categoryLabel, attribute: .leading, relatedBy: .equal, toItem: nameLabel, attribute: .leading, multiplier: 1.0, constant: 0),
                         NSLayoutConstraint(item: categoryLabel, attribute: .bottom, relatedBy: .equal, toItem: imageView, attribute: .bottom, multiplier: 1.0, constant: -6)]
        addConstraints(categoryLabelConstraints)
    }

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
