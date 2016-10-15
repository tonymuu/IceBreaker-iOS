//
//  YourProfileViewController.swift
//  icebreaker
//
//  Created by Tony Mu on 10/14/16.
//  Copyright © 2016 ibs. All rights reserved.
//

import UIKit
import Alamofire

class YourProfileViewController: UIViewController {
    
    @IBOutlet weak var line1: UITextField!
    @IBOutlet weak var line2: UITextField!
    @IBOutlet weak var line3: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func saveButtonClick(_ sender: AnyObject) {
        let bioLines = [line1.text!, line2.text!, line3.text!] as [String]
        let bioString = bioLines.joined(separator: Constants.bioDelimiter) as! String
        let dict = ["info": bioString]
        Alamofire.request(Constants.URIs.baseUri + Constants.routes.updateInfo, method: .post, parameters: dict, encoding: URLEncoding.default).responseJSON { response in switch response.result {
            case .success(let data):
                print("success updated info")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let token: String = FBSDKAccessToken.current().tokenString
        let params = ["access_token": token]
        Alamofire.request(Constants.URIs.baseUri + Constants.routes.auth, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { response in
                Alamofire.request(Constants.URIs.baseUri + Constants.routes.getUser, method: .get, parameters: nil, encoding: URLEncoding.default).responseJSON { response in switch response.result {
                case .success(let data):
                    let raw = data as! NSDictionary
                    let dict = raw.object(forKey: "facebook") as! NSDictionary
                    let profilePicString = dict.object(forKey: "picture") as! String
                    let profilePicUrl = URL(string: profilePicString)
                    if let imgData = try? UIImage(data: Data(contentsOf: profilePicUrl!)) {
                        self.profileImage.image = imgData
                    }
                    
                    if let bioString = dict.object(forKey: "bio") as! String? {
                        let bioLines = bioString.components(separatedBy: Constants.bioDelimiter)
                        self.line1.text = bioLines[0]
                        self.line2.text = bioLines[1]
                        self.line3.text = bioLines[2]
                    }
                    
                case .failure(let error):
                    print(error)
                    }
                }
        }
    }
    
    override func viewDidLayoutSubviews() {
        let border1 = CALayer()
        let width = CGFloat(1.0)
        border1.borderColor = UIColor.darkGray.cgColor
        border1.frame = CGRect(x: 0, y: line1.frame.size.height - width, width:  line1.frame.size.width, height: line1.frame.size.height)
        border1.borderWidth = width
        line1.layer.addSublayer(border1)
        line1.layer.masksToBounds = true
        
        let border2 = CALayer()
        border2.borderColor = UIColor.darkGray.cgColor
        border2.borderWidth = width
        border2.frame = CGRect(x: 0, y: line2.frame.size.height - width, width:  line2.frame.size.width, height: line2.frame.size.height)
        line2.layer.addSublayer(border2)
        line2.layer.masksToBounds = true
        
        let border3 = CALayer()
        border3.borderColor = UIColor.darkGray.cgColor
        border3.borderWidth = width
        border3.frame = CGRect(x: 0, y: line3.frame.size.height - width, width:  line3.frame.size.width, height: line3.frame.size.height)
        line3.layer.addSublayer(border3)
        line3.layer.masksToBounds = true

        
    }
}
