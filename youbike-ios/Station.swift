//
//  part2.swift
//  youbike-ios
//
//  Created by 陳冠華 on 2017/2/15.
//  Copyright © 2017年 my app. All rights reserved.
//

import Foundation

class Station {
    var name: String
    var address: String
    var numberOfRemainingBikes: String
    var latitude: String
    var longitude: String
    init (name: String, address: String, numberOfRemainingBikes: String, latitude: String, longitude: String) {
        self.name = name
        self.address = address
        self.numberOfRemainingBikes = numberOfRemainingBikes
        self.latitude = latitude
        self.longitude = longitude
    }
}
