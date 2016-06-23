//
//  ViewController.swift
//  KnurldTest
//
//  Created by Sara Du on 6/22/16.
//  Copyright © 2016 Sara Du. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    var json = JSON([])
    var accessToken = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let params = [
            "client_id": "D7cAa01QbDCjHKjMQHvoi5GMJyhlPrGy",
            "client_secret": "KPhSuyMrV9pYqPIz"
        ]
        
        let headers = [
             "Content-Type" : "application/x-www-form-urlencoded"
        ]
        
        let url = "https://api.knurld.io/oauth/client_credential/accesstoken?grant_type=client_credentials"
        Alamofire.request(.POST, url, parameters: params, headers: headers)
            .responseJSON { response in
                print(response.request)
                print(response.response)
                print(response.data)
                print(response.result)


        }
        
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

