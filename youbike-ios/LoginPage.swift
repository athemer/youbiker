//
//  LoginPage.swift
//  youbike-ios
//
//  Created by 陳冠華 on 2017/2/16.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
class LoginPage: UIViewController, FBSDKLoginButtonDelegate {
    var dict: [String: AnyObject]!
    let youBikeManager = YouBikeManager()
    @IBOutlet weak var youBikeHead: UILabel!
    @IBOutlet weak var bikeBackground: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoginStatus()
        //custom YouBike Head
        let strokeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.init(red: 254/255, green: 241/255, blue: 220/255, alpha: 1),
            NSForegroundColorAttributeName: UIColor.init(red: 61/255, green: 52/255, blue: 66/255, alpha: 1),
            NSStrokeWidthAttributeName: -1.0
            ] as [String : Any]
        youBikeHead.attributedText = NSAttributedString(string: "YouBike", attributes: strokeTextAttributes)
        //custom logo background
        bikeBackground.layer.cornerRadius = bikeBackground.frame.size.width / 2
        bikeBackground.layer.borderWidth = 1
        bikeBackground.layer.borderColor = UIColor(red: 61/255, green: 52/255, blue: 66/255, alpha: 1).cgColor
        let customFBButton = UIButton()
        customFBButton.backgroundColor = UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        customFBButton.frame = CGRect(x: 68, y: 302, width: 240, height: 64)
        customFBButton.setTitle("Log in With Facebook", for: .normal)
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        customFBButton.layer.cornerRadius = 10
        customFBButton.setTitleColor(.white, for: .normal)
        view.addSubview(customFBButton)

        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
//        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 16, y: 100, width: view.frame.width - 32, height: 50)
        loginButton.readPermissions = ["public_profile", "email"]
    }
    func handleCustomFBLogin () {
        FBSDKLoginManager().logIn(withReadPermissions : ["email", "public_profile"], from : self) { (_ /*result*/, error) in
            if error != nil {
                print ("Custom FB Login failed")
            }
            self.grabUserInfo()
            self.youBikeManager.signInWithFacebook(accessToken: FBSDKAccessToken.current())
            self.checkLoginStatus()
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print ("Did log out of facebook")
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print (error)
            return
        }
       grabUserInfo()
    }
    func grabUserInfo () {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name , email, link, picture"]).start { (_/*connection*/, result, error) in
            if error != nil {
                print ("error is happening")
                return
            } else {
                // swiftlint:disable:next force_cast
                self.dict = result as! [String : AnyObject]
                // swiftlint:disable:previous force_cast
                let infoArray = ["id", "name", "email", "link", "picture"]
                let defaults = UserDefaults.standard
                for infos in infoArray {
                    defaults.set(self.dict["\(infos)"], forKey: "\(infos)")
                }
            defaults.synchronize()
            }
        }
    }
    func checkLoginStatus () {
        if FBSDKAccessToken.current() != nil {
            performSegue(withIdentifier: "LoingToStation", sender: nil)
        } else {
            print ("not logged in")
        }
    }
}
