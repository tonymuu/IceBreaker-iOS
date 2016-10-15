//
//  YourProfileViewController.swift
//  icebreaker
//
//  Created by Tony Mu on 10/14/16.
//  Copyright © 2016 ibs. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKLoginKit

class YourProfileViewController: UIViewController {
    
    @IBOutlet weak var line1: UITextField!
    @IBOutlet weak var line2: UITextField!
    @IBOutlet weak var line3: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func logoutButtonClick(_ sender: AnyObject) {
        FBSDKLoginManager().logOut()
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func saveButtonClick(_ sender: AnyObject) {
        let bioLines = [line1.text!, line2.text!, line3.text!] as [String]
        let bioString = bioLines.joined(separator: Constants.bioDelimiter) 
        let dict = ["info": bioString]
        Alamofire.request(Constants.URIs.baseUri + Constants.routes.updateInfo, method: .post, parameters: dict, encoding: URLEncoding.default).responseJSON { response in
                print("success updated info")
                Alamofire.request(Constants.URIs.baseUri + Constants.routes.getAllPeers, method: .post, parameters: nil, encoding: URLEncoding.default).responseJSON { response in switch response.result {
                case .success(let data):
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NearbyVC") as! PrimerViewController
                    vc.lessonsArray = data as! [NSDictionary]
                    self.present(vc, animated: true, completion: nil)
                case .failure(let error):
                    print(error)
                    }
            }
        }
    }
    
    fileprivate func generateProfileImageView(_ urlString: String) -> UIView {
        let hw = self.navigationController?.navigationBar.frame.size.height
        let imgViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let imgView = UIImageView(frame: imgViewContainer.frame)
        let url = URL(string: urlString)
        if let imgData = try? Data(contentsOf: url!) {
            imgView.image = UIImage(data: imgData)
            imgViewContainer.layer.cornerRadius = hw! / 2
            imgViewContainer.layer.borderWidth = 1.5
            imgViewContainer.layer.borderColor = (UIColor.white).cgColor
            imgViewContainer.clipsToBounds = true
            imgView.contentMode = .scaleAspectFill
            
            imgViewContainer.addSubview(imgView)
        }
        
        
        return imgViewContainer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGestureRecognizer)

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
                        let imgViewContainer = UIView(frame: self.profileImage.frame)
                        self.profileImage.layer.cornerRadius = imgViewContainer.frame.width / 2
                        self.profileImage.layer.borderWidth = 10.0
                        self.profileImage.layer.borderColor = Constants.backgroundColor.light.cgColor
                        self.profileImage.clipsToBounds = true
                        self.profileImage.contentMode = .scaleAspectFill
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
        border1.frame = CGRect(x: 0, y: line1.frame.size.height - width, width:  line1.frame.size.width, height: line1.frame.size.height)
        border1.borderWidth = width
        border1.borderColor = UIColor.lightGray.cgColor
        line1.layer.addSublayer(border1)
        line1.layer.masksToBounds = true
        
        let border2 = CALayer()
        border2.borderWidth = width
        border2.frame = CGRect(x: 0, y: line2.frame.size.height - width, width:  line2.frame.size.width, height: line2.frame.size.height)
        border2.borderColor = UIColor.lightGray.cgColor
        line2.layer.addSublayer(border2)
        line2.layer.masksToBounds = true
        
        let border3 = CALayer()
        border3.borderWidth = width
        border3.frame = CGRect(x: 0, y: line3.frame.size.height - width, width:  line3.frame.size.width, height: line3.frame.size.height)
        border3.borderColor = UIColor.lightGray.cgColor
        line3.layer.addSublayer(border3)
        line3.layer.masksToBounds = true
    }
    
    func dismissKeyboard() {
        line2.resignFirstResponder()
        line3.resignFirstResponder()
        line1.resignFirstResponder()
    }

}
