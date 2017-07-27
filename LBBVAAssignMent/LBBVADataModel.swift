//
//  LBBVADataModel.swift
//  LBBVAAssignMent
//
//  Created by laxman penmetsa on 7/26/17.
//  Copyright © 2017 com.laxman. All rights reserved.
//

import Foundation

struct CellModel {
    var country:String?
    var name:String?
    var abbr:String?
    var area:String?
    var largestCity:String?
    var capital:String?
}

protocol DataModelDelegate {
    func dataParsingCompleted()
}

class LBBVADataModel: NSObject
{
    let REQUEST_URL = "http://services.groupkt.com/state/get/USA/all"
    let REST_RESPONSE_KEY = "RestResponse"
    let RESULT_KEY  = "result"
    let COUNTRY_KEY = "country"
    let NAME_KEY = "name"
    let ABBR_KEY = "abbr"
    let CAPITAL_KEY = "capital"
    let LARGESTCITY_KEY = "largest_city"
    let AREA_KEY = "area"
    
    var delegate : DataModelDelegate!
    var cellModelArray :[CellModel]? = []
    func fetchDataFromServer() {
        guard let requestURL = URL(string: REQUEST_URL) else {return}
        let fetchService = LBBVAFetchService()
        fetchService.delegate = self
        fetchService.fetchDataFrom(requestURL)
        
    }
}

extension LBBVADataModel:FetchServiceDelegate
{
    func didRecieveResponse(withData data:Data?)
    {
        do{
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
            print(json)
            if  let restResponse = json[REST_RESPONSE_KEY] as? [String:AnyObject]{
                if let results = restResponse[RESULT_KEY] as?[[String: AnyObject]]{
                    for result in results{
                        var cellModel = CellModel()
                        if let country = result[COUNTRY_KEY], let name = result[NAME_KEY], let abbr = result[ABBR_KEY], let largestCity = result[LARGESTCITY_KEY], let capital = result[CAPITAL_KEY] , let area = result[AREA_KEY]{
                            cellModel.country = country as? String
                            cellModel.name = name as? String
                            cellModel.abbr = abbr as? String
                            cellModel.largestCity = largestCity as? String
                            cellModel.capital = capital as? String
                            let areaString = area as? String
                            cellModel.area = areaString?.convertAreaInKmSToMilesS()
                            
                        }
                        self.cellModelArray?.append(cellModel)
                    }
                }
            }
            
        }catch{
            print(error)
        }
        self.delegate.dataParsingCompleted()
    }
}


extension String{
    func convertAreaInKmSToMilesS() -> String {
        let componentsArray = self.components(separatedBy: "S")
        let value:Int = Int(componentsArray.first!)!
        let milesValue = Int(0.621371*Double(value))
        return "\(milesValue)SM"
    }
}
