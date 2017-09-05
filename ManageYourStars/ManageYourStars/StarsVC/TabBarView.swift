//
//  TabBarView.swift
//  ManageYourStars
//
//  Created by 陈仕鹏 on 2017/9/5.
//  Copyright © 2017年 csp. All rights reserved.
//

import UIKit

class TabBarView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var whiteBar: UIView!
    @IBOutlet weak var whiteBarLeadingConstraint: NSLayoutConstraint!
    private let desArray = ["Repositories", "Following", "Follower"]
    var selectedIndex = 0
    var countArray = [Int](){
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    //MARK: Methods
    func customization() {
        if let coll = self.collectionView {
            print("\(coll)")
        }else{
            print("collection view is nill")
        }
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(self.animateMenu(notification:)), name: Notification.Name.init(rawValue: "scrollMenu"), object: nil)
    }
    
    func animateMenu(notification: Notification) {
        if let info = notification.userInfo {
            let userInfo = info as! [String: CGFloat]
            self.whiteBarLeadingConstraint.constant = self.whiteBar.bounds.width * userInfo["length"]!
            self.selectedIndex = Int(round(userInfo["length"]!))
            self.layoutIfNeeded()
            self.collectionView.reloadData()
        }
    }
    
    //MARK: Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.desArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! TabBarCellCollectionViewCell
        let des = self.desArray[indexPath.row]
        if self.selectedIndex == indexPath.row {
            
            if countArray.count > 0 {
                cell.countLabel.text = "\(countArray[indexPath.row])"
                cell.countLabel.textColor = UIColor(red: 160.0/255, green: 32/255.0, blue: 24/255.0, alpha: 1.0)
                cell.desLabel.textColor = UIColor(red: 160.0/255, green: 32/255.0, blue: 24/255.0, alpha: 1.0)

            }else{
                cell.countLabel.text = "0"
                cell.countLabel.textColor = UIColor.black
                cell.desLabel.textColor = UIColor.black
            }
            
        }else{
            if countArray.count > 0 {
                cell.countLabel.text = "\(countArray[indexPath.row])"

            }
            cell.countLabel.text = "0"
            cell.countLabel.textColor = UIColor.black
            cell.desLabel.textColor = UIColor.black
        }
        
        cell.desLabel.text = des;
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.bounds.width / 3, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.selectedIndex != indexPath.row {
            self.selectedIndex = indexPath.row
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "didSelectMenu"), object: nil, userInfo: ["index": self.selectedIndex])
        }
    }
    
    //MARK: View LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.customization()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//TabBarCell Class
class TabBarCellCollectionViewCell: UICollectionViewCell {
    //    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    
}
