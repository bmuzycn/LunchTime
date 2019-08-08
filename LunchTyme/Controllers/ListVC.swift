//
//  LunchVC.swift
//  LunchTyme
//
//  Created by Yu Zhang on 7/30/19.
//  Copyright © 2019 Yu Zhang. All rights reserved.
//

import UIKit

class ListVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let titleFont: UIFont = UIFont.init(name: "AvenirNext-DemiBold", size: 17)!
    
    private let cellID = "listCell"
    
    private let cellHeight: CGFloat = 180
    
    private var imagesURL = Array<URL>()
    
    private var names = Array<String>()
    
    private var categories = Array<String>()
    
    private var addresses = Array<[String]>()
    
    private var lats = Array<Double>()
    
    private var lngs = Array<Double>()
    
    private var phones = Array<String>()
    
    private var twitters = Array<String>()
    
    private var fetchResult = Array<Restaurant>()

    private var numberOfCell = 0
    
    fileprivate func fetchData() {
        NetworkHelper.getData { (result) in
            if let result = result as? [Restaurant]{
                self.fetchResult = result
                self.numberOfCell = result.count
                for restaurant in result {
                    let imageURL = restaurant.backgroundImageURL
                    self.imagesURL.append(imageURL)
                    self.names.append(restaurant.name)
                    self.categories.append(restaurant.category)
                    self.addresses.append(restaurant.location.formattedAddress)
                    self.phones.append(restaurant.contact?.formattedPhone ?? "")
                    self.twitters.append(restaurant.contact?.twitter ?? "")
                    self.lats.append(restaurant.location.lat)
                    self.lngs.append(restaurant.location.lng)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.setNeedsLayout()
        fetchData()
        
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.alwaysBounceVertical = true

        //Mark: set map button here:
        let mapButton = UIBarButtonItem(image: UIImage(named: "icon_map"), style: .plain, target: self, action: #selector(pressMapButton))
        self.navigationItem.setRightBarButton(mapButton, animated: true)
        
        // set title here:
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        title.text = "Lunch Tyme"
        title.font = titleFont
        title.textColor = UIColor.white
        navigationItem.titleView = title
        
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: UIDevice.orientationDidChangeNotification, object: nil)

    }
    
    // segue to mapView
    @objc func pressMapButton() {
        let mapVC = DetailVC()
        mapVC.restaurants = fetchResult
        mapVC.mapConstrainForFull()
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    @objc func orientationDidChange() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Do some delegate methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCell
    }
    
    
    // set cell size here:
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.size.width
        let cellwidth = screenWidth
        let model = UIDevice.current.model
        if model.contains("iPad") {
            return CGSize(width: cellwidth/2, height: cellHeight)
        }
        return CGSize(width: cellwidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //segue to detailVC
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailVC()
        detailVC.nameLabel.text = names[indexPath.item]
        detailVC.categoryLabel.text = categories[indexPath.item]
        detailVC.address1Label.text = addresses[indexPath.item][0]
        detailVC.address2Label.text = addresses[indexPath.item][1]
        detailVC.phoneLabel.text = phones[indexPath.item]
        detailVC.twitterLabel.text = "@\(twitters[indexPath.item])"
//        detailVC.lat = lats[indexPath.item]
//        detailVC.lng = lngs[indexPath.item]
        detailVC.restaurants = [fetchResult[indexPath.item]]
        detailVC.updateLayout()
        print(addresses[indexPath.item][0])
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    // return reuseable cell:
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ListCell
        if indexPath.item < imagesURL.count {
            let url = imagesURL[indexPath.item]
            
            /*   get image data using cache        */
            cell.imageView.loadImageAsync(with: url.absoluteString)
            cell.nameLabel.text = self.names[indexPath.item]
            cell.categoryLabel.text = self.categories[indexPath.item]
        }

        let bgView = UIImageView(frame: cell.frame)
        bgView.image = UIImage(named: "cellGradientBackground")
        bgView.contentMode = .scaleToFill
        bgView.frame = cell.frame
        cell.backgroundView = bgView
        return cell
    }

    
    // MARK: loading image urls
    func loadImagesURL(_ result: [Restaurant]) {
        for restautant in result {
            let imageURL = restautant.backgroundImageURL
            imagesURL.append(imageURL)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    //MARK: remove the back button text
    override func viewWillDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}




