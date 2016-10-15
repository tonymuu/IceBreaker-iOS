import Foundation
import UIKit.UIColor

struct Constants {
    static let images = [UIImage(named: "home-1.jpg"), UIImage(named: "home-2.jpg"), UIImage(named: "home-3.jpg")]
    
    static let bioDelimiter = "%@"
    
    struct backgroundColor {
        static let light = UIColor(colorLiteralRed: 0.56, green: 0.62, blue: 0.71, alpha: 1.0)
        static let dark = UIColor(colorLiteralRed: 56, green: 62, blue: 71, alpha: 1.0)
    }
    
    struct size {
        static let bttfHeight = 40
    }
    
    struct URIs {
        // production url
        static let baseUri = "https://icebreaker-prod.herokuapp.com"
        
        // dev url
//        static let baseUri = "http://localhost:3000"
        
    }
    
    struct routes {
        static let auth = "/auth/facebook/token"
        static let addUser = "/add_user"
        static let getUser = "/get_user"
        static let updateInfo = "/update_info"
        static let getAllPeers = "/get_all_peers"
        static let getPeers = "/get_peers"
    }
}

