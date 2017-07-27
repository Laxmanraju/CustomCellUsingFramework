//
//  LBBVAFetchService.swift
//  LBBVAAssignMent
//
//  Created by laxman penmetsa on 7/26/17.
//  Copyright © 2017 com.laxman. All rights reserved.
//

import Foundation

protocol FetchServiceDelegate {
    func didRecieveResponse(withData data:Data?)
}

class LBBVAFetchService: NSObject {
    
    var delegate:FetchServiceDelegate!
    
    func fetchDataFrom(_ url:URL) {
        
        URLSession.shared.dataTask(with:url) { (data, response, error) in
            if error != nil {
                print(error ?? "Error Fetching data")
            } else {
                if let data = data{
                    self.delegate.didRecieveResponse(withData: data)
                }
            }
        }.resume()
    }
}
