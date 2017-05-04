//
//  profilePage.swift
//  youbike-ios
//
//  Created by 陳冠華 on 2017/2/18.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfilePage: UIViewController {
    let defaults = UserDefaults.standard
    let manager = YouBikeManager()

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var cardBase: UIView!
    @IBOutlet weak var pictureBack: UIView!
    @IBOutlet weak var facebookPageBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        cardBase.layer.cornerRadius = 20
        cardBase.layer.shadowPath = UIBezierPath(rect: cardBase.bounds).cgPath
        cardBase.layer.shadowOpacity = 0.5
        cardBase.layer.shadowOffset = CGSize.zero
        cardBase.layer.shadowRadius = 20
        nameLabel.text =  "\(defaults.object(forKey: "name")!)"
        guard let picture = defaults.object(forKey: "picture") as? NSDictionary else { return }
        let data = picture.object(forKey: "data") as AnyObject
        guard let picURL = data.object(forKey: "url") as? String else { return }
        let urlToPass = URL(string: picURL)
        guard let dataAccessToPic = try? Data(contentsOf: urlToPass! as URL) else { return }

        profilePicture.layer.masksToBounds = true
        profilePicture.layer.cornerRadius = 69
        pictureBack.layer.cornerRadius = 75
        facebookPageBtn.layer.cornerRadius = 10
        self.profilePicture.image = UIImage(data: dataAccessToPic)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func fbBtnTapped(_ sender: Any) {
    // swiftlint:disable:next force_cast
        let linkToFBPage = defaults.object(forKey: "link") as! String
    // swiftlint:disable:previous force_cast
        let urlToFB = URL(string: linkToFBPage)
        UIApplication.shared.open(urlToFB!, options: [:], completionHandler: nil)
        print (linkToFBPage)
    }

}
