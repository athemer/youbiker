//
//  mainPageCell.swift
//  youbike-ios
//
//  Created by 陳冠華 on 2017/2/16.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class MainPageCell: UITableViewCell {
    var printer: String!
    let mapPage = MapViewController()
    @IBOutlet weak var stationNameLabel: UILabel!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var stationLocationLabel: UILabel!
    @IBOutlet weak var numberOfRemainingBikeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        mapBtn.layer.cornerRadius = 4
        mapBtn.layer.borderWidth = 1
        mapBtn.layer.borderColor = UIColor(red: 204/255, green: 113/255, blue: 93/255, alpha: 1).cgColor
        mapBtn.layer.backgroundColor = UIColor.clear.cgColor
        mapBtn.addTarget(self, action: #selector(mapBtnTapped), for: .touchUpInside)

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func mapBtnTapped (sender: UIButton) {
            print (printer)
    }

}
