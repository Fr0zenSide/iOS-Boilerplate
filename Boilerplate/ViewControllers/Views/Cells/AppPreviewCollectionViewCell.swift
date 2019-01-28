//
//  AppPreviewCollectionViewCell.swift
//  Boilerplate
//
//  Created by Jeoffrey Thirot on 09/11/2018.
//  Copyright © 2018 Jeoffrey Thirot. All rights reserved.
//

import UIKit
import QuartzCore

class AppPreviewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    // Private variables
    
    // Public variables
    
    static let cellCornerRadius: CGFloat = 12
    
    var data: App?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundTitleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    // MARK: - Getter & Setter methods
    
    // MARK: - Constructors
    
    // MARK: - Init behaviors
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundImageView.contentMode = .scaleAspectFill
        self.layer.cornerRadius = AppPreviewCollectionViewCell.cellCornerRadius
        self.clipsToBounds = true
    }
    
    // MARK: - Public methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        data = nil
        backgroundImageView.image = nil
        titleLabel.text = ""
        bottomLabel.text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if data != nil {
            titleLabel.text = data?.title
            bottomLabel.text = data?.developer
            // implementation of simple cache
            // todo: use a method to load image with a progression to display with a placeholder
            // can use an NSCache object to display the image faster
            data?.getIcon(complete: { (image) in
                self.backgroundImageView.image = image
            })
        }
    }
    
    // MARK: - Private methods
}
