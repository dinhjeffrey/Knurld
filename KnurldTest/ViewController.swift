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
    var enrollmentID = ""
    
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
                if let accessToken = response.result.value?["access_token"] {
                    self.accessToken = accessToken as! String
                }
        }
    }

    func createConsumer(name: String, gender: String, password: String){
        let url = "https://api.knurld.io/v1/consumers"
        let params = [
            "username": name,
            "gender": gender,
            "password": password
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken,
            "Developer-Id" : "Bearer: eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MDQ4MTY5MDUsInJvbGUiOiJhZG1pbiIsImlkIjoiZWNkMTAwM2YzODJlNWEzZjU0NGQyZjFkY2Y3YmNmYjUiLCJ0ZW5hbnQiOiJ0ZW5hbnRfbXJwdGF4M2xuenl4cXpsem5qeHhhenR2bzQyaHU2dHBudnpkZTVsYnBpenc0M2xnb3YzeHMzZHVtcnhkazUzciIsIm5hbWUiOiJhZG1pbiJ9.El88CANBe5C_KLpYlP7dc-5-dwF-zPFGk2YeubNobm59uM2Sx9NbVGcN5n7smm4izo1s0RsrVKHBd9mH4hkPQA"
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: params)

        Alamofire.request(.POST, url, parameters: params, headers: headers, encoding: .JSON)
            .responseJSON { response in
                
        }
    }
    
    func createEnrollment(consumer: String, application: String) {
        let url = "https://api.knurld.io/v1/enrollments/"
        let params = [
            "consumer": consumer,
            "application": application
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken,
            "Developer-Id" : "Bearer: eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MDQ4MTY5MDUsInJvbGUiOiJhZG1pbiIsImlkIjoiZWNkMTAwM2YzODJlNWEzZjU0NGQyZjFkY2Y3YmNmYjUiLCJ0ZW5hbnQiOiJ0ZW5hbnRfbXJwdGF4M2xuenl4cXpsem5qeHhhenR2bzQyaHU2dHBudnpkZTVsYnBpenc0M2xnb3YzeHMzZHVtcnhkazUzciIsIm5hbWUiOiJhZG1pbiJ9.El88CANBe5C_KLpYlP7dc-5-dwF-zPFGk2YeubNobm59uM2Sx9NbVGcN5n7smm4izo1s0RsrVKHBd9mH4hkPQA"
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: params)
        
        
        Alamofire.request(.POST, url, parameters: params, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let enrollmentID = response.result.value?["href"] {
                    self.enrollmentID = enrollmentID as! String
                }
        }
    }
    typealias TimePosition = Int
    struct Interval {
        var phrase: String
        var start: TimePosition
        var stop: TimePosition
    }
    
    func populateEnrollment(audioLink: NSURL,
                            intervals: [Interval] ) {
        let url = enrollmentID
        let intervalsDictionary = [
            [
                "phrase": intervals[0],
                "start": intervals[1],
                "stop": intervals[2],
            ]
        ]
        
        let params : [String: AnyObject] = [
            "enrollment.wav": audioLink,
            "intervals": (intervalsDictionary as? AnyObject)!
        ]
        
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer " + accessToken,
            "Developer-Id" : "Bearer: eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MDQ4MTY5MDUsInJvbGUiOiJhZG1pbiIsImlkIjoiZWNkMTAwM2YzODJlNWEzZjU0NGQyZjFkY2Y3YmNmYjUiLCJ0ZW5hbnQiOiJ0ZW5hbnRfbXJwdGF4M2xuenl4cXpsem5qeHhhenR2bzQyaHU2dHBudnpkZTVsYnBpenc0M2xnb3YzeHMzZHVtcnhkazUzciIsIm5hbWUiOiJhZG1pbiJ9.El88CANBe5C_KLpYlP7dc-5-dwF-zPFGk2YeubNobm59uM2Sx9NbVGcN5n7smm4izo1s0RsrVKHBd9mH4hkPQA"
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: params)
        
        Alamofire.request(.POST, url, parameters: params, headers: headers, encoding: .JSON)
            .responseJSON { response in
                print(response)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

