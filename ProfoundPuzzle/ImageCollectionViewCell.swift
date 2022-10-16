//
//  ImageCollectionViewCell.swift
//  ProfoundPuzzle
//
//  Created by Hannah Chen on 10/15/22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var puzzleImage: UIImageView!
    
    override func awakeFromNib() {
        self.frame = puzzleImage.frame
    }
    
}
