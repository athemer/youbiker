//
//  YoubikeManager.swift
//  youbike-ios
//
//  Created by 陳冠華 on 2017/2/21.
//  Copyright © 2017年 my app. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Alamofire

protocol YoubikeManagerDelegate: class {
    func manager(_ manager: YouBikeManager, didGet stations: [Station])
    func manager(_ manager: YouBikeManager, didFailWith error: Error)
    }

class YouBikeManager {
    static let shared = YouBikeManager()
    weak var delegate: YoubikeManagerDelegate?

    let defaults = UserDefaults.standard
    func signInWithFacebook(accessToken: FBSDKAccessToken) {

        let json: [String: Any] = ["accessToken": FBSDKAccessToken.current().tokenString]
        print(json)
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "http://52.34.47.148/sign-in/facebook")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, _ /*response*/, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("Check response status \(responseJSON)")
                let JWT = responseJSON["data"] as? [String: Any]
                print ("JWT HERE\(JWT)")
                let tokenFromResponse = JWT?["token"]
                let tokenTypeFromResponse = JWT?["tokenType"]
                self.defaults.set(tokenFromResponse, forKey: "token")
                self.defaults.set(tokenTypeFromResponse, forKey: "tokenType")
                self.defaults.synchronize()
            }
        }
        task.resume()
        return
    }
    func getStations() {
        let headers: HTTPHeaders = [
            "Authorization": "\(defaults.object(forKey: "tokenType")!) \(defaults.object(forKey: "token")!)"]
        Alamofire.request("http://52.34.47.148/stations", method: .get, headers: headers).responseJSON { (response) in
            let stationsData = self.transferToStationsData(response: response.result.value as AnyObject)
            print ("Man.... \(response)")
            print("How is this happening ?\(stationsData)")
            if stationsData.count != 0 {
                DispatchQueue.main.async {
                    self.delegate?.manager(self, didGet: stationsData)
                }
        }
    }
    }
//        let url = URL(string: "http://52.34.47.148/stations")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("\(defaults.object(forKey: "tokenType")!) \(defaults.object(forKey: "token")!)", forHTTPHeaderField: "Authorization")
//        
//
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(error?.localizedDescription ?? "No data")
//                print ("something goes wrong ")
//           return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
//            if let responseJSON = responseJSON as? [String: Any] {
//                print("------------------\n------------------\n\(responseJSON)\n------------------\n------------------\n")
//            }
//           UserDefaults.standard.set(responseJSON, forKey: "JWT")
//            let stationsData = self.transferToStationsData(response: responseJSON as AnyObject)
//            print(stationsData)            
//            if stationsData.count != 0 {
//                self.delegate?.manager(YouBikeManager.shared, didGet: stationsData)
//                print ("okay")
//                
//            }
//            
//            DispatchQueue.main.async {
//                self.delegate?.manager(self, didGet: stationsData)
//            }
//        }
//        task.resume()
//    }

    func transferToStationsData(response: AnyObject) -> [Station] {
        var returnArray: [Station] = []
        guard let arrayStations = response["data"] as? [AnyObject] else { return [] }
        print("hmmmmm \(arrayStations)")
        for station in arrayStations {
            if let name = station["sna"] as? String, let address = station["ar"] as? String, let numberOfRemainingBikes = station["sbi"] as? String, let latitude = station["lat"] as? String, let longitude = station["lng"] as? String {
                returnArray.append(Station(name: name, address: address, numberOfRemainingBikes: numberOfRemainingBikes, latitude: latitude, longitude: longitude))
            }
        }
        print("ARRAY IS \(returnArray)")
        return returnArray
    }
}
