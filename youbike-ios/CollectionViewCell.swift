//
//  CollectionViewCell.swift
//  youbike-ios
//
//  Created by 陳冠華 on 2017/3/1.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var stationName: UILabel!
    @IBOutlet weak var numberOfRemainingBikes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
