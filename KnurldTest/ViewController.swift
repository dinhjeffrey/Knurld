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
    typealias url = String
    var json = JSON([])
    static var developerID = "Bearer: eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1MDQ4MTY5MDUsInJvbGUiOiJhZG1pbiIsImlkIjoiZWNkMTAwM2YzODJlNWEzZjU0NGQyZjFkY2Y3YmNmYjUiLCJ0ZW5hbnQiOiJ0ZW5hbnRfbXJwdGF4M2xuenl4cXpsem5qeHhhenR2bzQyaHU2dHBudnpkZTVsYnBpenc0M2xnb3YzeHMzZHVtcnhkazUzciIsIm5hbWUiOiJhZG1pbiJ9.El88CANBe5C_KLpYlP7dc-5-dwF-zPFGk2YeubNobm59uM2Sx9NbVGcN5n7smm4izo1s0RsrVKHBd9mH4hkPQA"
    static var accessToken = String()
    var appModelID = url()
    var consumerID = url()
    var enrollmentID = url()
    var verificationID = url()
    var callID = url()
    var taskNameID = url()
    var intervalsJson = [AnyObject]()
    
    func encodeJson(url: String, params: [String: AnyObject]) -> [String: AnyObject] {
        var request = NSMutableURLRequest(URL: NSURL(fileURLWithPath: url))
        let encoding = Alamofire.ParameterEncoding.URL
        (request, _) = encoding.encode(request, parameters: params)
        return params
    }
    lazy var headers = [
        "Content-Type": "application/json",
        "Authorization": accessToken,
        "Developer-Id" : developerID
    ]
    
    
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
                if let accessToken = response.result.value?["access_token"] as? String {
                    ViewController.accessToken = "Bearer " + accessToken
                    print(accessToken)
                }
        }
    }
    
    func createAppModel(enrollmentRepeats: Int, vocabulary: [String], verificationLength: Int) {
        let url = "https://api.knurld.io/v1/app-models"
        let params: [String: AnyObject] = [
            "enrollmentRepeats": enrollmentRepeats,
            "vocabulary": vocabulary,
            "verificationLength": verificationLength
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                print(response)
                if let appModelID = response.result.value?["href"] as? String {
                    self.appModelID = appModelID
                    print(appModelID)
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
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let consumerID = response.result.value?["href"] as? String {
                    self.consumerID = consumerID
                    print(consumerID)
                }
        }
    }
    
    func createEnrollment(consumer: url, application: url) {
        let url = "https://api.knurld.io/v1/enrollments/"
        let params = [
            "consumer": consumer,
            "application": application
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let enrollmentID = response.result.value?["href"] as? String {
                    self.enrollmentID = enrollmentID
                }
        }
    }
    typealias TimePosition = Int
    struct Interval {
        typealias phrase = String
        typealias start = TimePosition
        typealias stop = TimePosition
    }
    
    func populateEnrollment(audioLink: url,
                            phrase: [Interval.phrase], start: [Interval.start], stop: [Interval.stop] ) {
        let url = enrollmentID
        guard url != "" else { print("didn't initiate enrollment yet"); return }
        var intervalsDictionary = [AnyObject]()
        
        for (index, _) in phrase.enumerate() {
            var intervals = [String: AnyObject]()
            intervals["phrase"] = phrase[index]
            intervals["start"] = start[index]
            intervals["stop"] = stop[index]
            intervalsDictionary.append(intervals)
        }
        
        let params : [String: AnyObject] = [
            "enrollment.wav": audioLink,
            "intervals": intervalsDictionary
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                print(response)
        }
    }
    
    func createVerification(consumer: url, application: url) {
        let url = "https://api.knurld.io/v1/verifications"
        let params = [
            "consumer": consumer,
            "application": application
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let verificationID = response.result.value?["href"] as? String {
                    self.verificationID = verificationID
                    print(verificationID)
                }
        }
    }
    
    func verifyVoiceprint(audioLink: url,
                          phrase: [Interval.phrase], start: [Interval.start], stop: [Interval.stop] ) {
        let url = verificationID
        guard url != "" else { print("didn't initiate verification yet"); return }
        var intervalsDictionary = [AnyObject]()
        for (index, _) in phrase.enumerate() {
            var intervals = [String: AnyObject]()
            intervals["phrase"] = phrase[index]
            intervals["start"] = start[index]
            intervals["stop"] = stop[index]
            intervalsDictionary.append(intervals)
        }
        
        let params : [String: AnyObject] = [
            "verification.wav": audioLink,
            "intervals": intervalsDictionary
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                print(response)
        }
    }
    
    func initiateCall(phoneNumber: String) {
        let url = "https://api.knurld.io/v1/calls"
        let params = [
            "number": phoneNumber
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let callID = response.result.value?["href"] as? String {
                    self.callID = callID
                    print(callID)
                }
        }
    }
    
    func terminateCall() {
        let url = callID
        guard url != "" else { print("didn't initiate call yet"); return }
        
        Alamofire.request(.POST, url, headers: headers)
            .responseJSON { response in
                print(response)
        }
    }
    
    func analysisByUrl(audioUrl: url, numWords: String) {
        let url = "https://api.knurld.io/v1/endpointAnalysis/url"
        let params = [
            "audioUrl": audioUrl,
            "words": numWords
        ]
        
        let encodedParams = encodeJson(url, params: params)
        
        Alamofire.request(.POST, url, parameters: encodedParams, headers: headers, encoding: .JSON)
            .responseJSON { response in
                if let taskNameID = response.result.value?["taskName"] as? String {
                    self.taskNameID = taskNameID
                    print(taskNameID)
                }
        }
    }
    
    func getAnalysis() {
        let url = "https://api.knurld.io/v1/endpointAnalysis/" + taskNameID
        guard taskNameID != "" else { print("didn't initiate analysis yet"); return }
        let headers = [
            "Authorization": ViewController.accessToken,
            "Developer-Id" : ViewController.developerID
        ]
        
        Alamofire.request(.GET, url, headers: headers)
            .responseJSON { response in
                if let intervalsJson = response.result.value?["intervals"] as? [AnyObject] {
                    self.intervalsJson = intervalsJson
                    print(intervalsJson)
                }
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

