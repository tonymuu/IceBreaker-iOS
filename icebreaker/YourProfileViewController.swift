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

    override func viewDidLoad() {
        super.viewDidLoad()
        let token: String = FBSDKAccessToken.current().tokenString
        let params = ["access_token": token]

        Alamofire.request(Constants.URIs.baseUri + Constants.routes.addUser, method: .post, parameters: params, encoding: URLEncoding.default).responseJSON { response in switch response.result {
        case .success(let data):
            let dict = data as! NSDictionary
        case .failure(let error):
            print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
