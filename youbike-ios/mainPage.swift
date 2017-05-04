//
//  ViewController.swift
//  youbike-ios
//
//  Created by 陳冠華 on 2017/2/15.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MainPage: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, YoubikeManagerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentControl: UIBarButtonItem!
    let mainPageCell = MainPageCell()
    let collectionViewCell = CollectionViewCell()
    let mapPage = MapViewController()
    var stations: [Station] = []
    let youBikeMaganer = YouBikeManager()
    override func viewDidLoad() {
        super.viewDidLoad()

        YouBikeManager.shared.delegate = self
        YouBikeManager.shared.signInWithFacebook(accessToken: FBSDKAccessToken.current())
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        self.navigationItem.title = "YouBike"
         }
    override func viewDidAppear(_ animated: Bool) {
        YouBikeManager.shared.getStations()
        print ("NOOOOOOOOOOOOOOO \(stations)")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as? MainPageCell else { return mainPageCell}
        cell.stationNameLabel.text = stations[indexPath.row].name
        cell.stationLocationLabel.text = stations[indexPath.row].address
        cell.numberOfRemainingBikeLabel.text = stations[indexPath.row].numberOfRemainingBikes
        cell.printer = stations[indexPath.row].name
        cell.mapBtn.tag = indexPath.row
        cell.mapBtn.addTarget(self, action: #selector(moveToMapPage), for: .touchUpInside)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier:"Detail") as? DetailViewController else { return }
        vc.stationName = stations[indexPath.row].name
        vc.latitudeString = stations[indexPath.row].latitude
        vc.longitudeString = stations[indexPath.row].longitude
        vc.roadName = stations[indexPath.row].address
        vc.numberleft = stations[indexPath.row].numberOfRemainingBikes
        self.navigationController?.pushViewController(vc, animated: true)
        return
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stations.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CollectionViewCell else { return collectionViewCell}
                cell.stationName.text = stations[indexPath.item].name
                cell.numberOfRemainingBikes.text = stations[indexPath.item].numberOfRemainingBikes
                return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier:"Detail") as? DetailViewController else { return }
        vc.stationName = stations[indexPath.item].name
        vc.latitudeString = stations[indexPath.item].latitude
        vc.longitudeString = stations[indexPath.item].longitude
        vc.roadName = stations[indexPath.item].address
        vc.numberleft = stations[indexPath.item].numberOfRemainingBikes
        self.navigationController?.pushViewController(vc, animated: true)
        return
    }
    func manager(_ manager: YouBikeManager, didGet stations: [Station]) {

        self.stations = stations
        tableView.reloadData()
        collectionView.reloadData()
        print(self.stations)
    }

    func manager(_ manager: YouBikeManager, didFailWith error: Error) {
        return
    }
    func moveToMapPage(sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier:"Map") as? MapViewController else { return }
        vc.stationName = stations[sender.tag].name
        vc.latitudeString = stations[sender.tag].latitude
        vc.longitudeString = stations[sender.tag].longitude
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        navigationItem.backBarButtonItem?.tintColor = UIColor.black
    }
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.tableView.isHidden = false
                self.collectionView.isHidden = true
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.tableView.isHidden = true
                self.collectionView.isHidden = false
            })
        }
    }
}
