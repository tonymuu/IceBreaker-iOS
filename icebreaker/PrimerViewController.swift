//
//  PrimerViewController.swift
//  StickyCollectionView
//
//  Created by Bogdan Matveev on 02/02/16.
//  Copyright © 2016 Bogdan Matveev. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit

class PrimerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let kDemoCell = "primerCell"
    let kCellSizeCoef: CGFloat = 0.8
    let kFirstItemTransform: CGFloat = 0.05
    
    var lessonsArray: [NSDictionary]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let stickyLayout = collectionView.collectionViewLayout as! StickyCollectionViewFlowLayout
        stickyLayout.firstItemTransform = kFirstItemTransform
    }
    
    func actionClose(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: collectionView.bounds.height * kCellSizeCoef)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: NSInteger) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lessonsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDemoCell, for: indexPath) as! PrimerCollectionViewCell
        let lesson = lessonsArray[indexPath.row]
        let dict = lesson.object(forKey: "facebook") as! NSDictionary
        let profilePicString = dict.object(forKey: "picture") as! String
        let profilePicUrl = URL(string: profilePicString)
        if let imgData = try? UIImage(data: Data(contentsOf: profilePicUrl!)) {
            cell.profileImageView.image = imgData
        }

        if let bioString = dict.object(forKey: "bio") as! String? {
            let bioLines = bioString.components(separatedBy: Constants.bioDelimiter)
            cell.line1.text = bioLines[0]
            cell.line2.text = bioLines[1]
            cell.line3.text = bioLines[2]
        }
        return cell
    }
}

//extension PrimerViewController: UICollectionViewDataSource {
//    
//}
//
//extension PrimerViewController: UICollectionViewDelegateFlowLayout {
//    
//}
//

