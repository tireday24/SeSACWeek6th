//
//  LocationAPI.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/14.
//

import Foundation

import Alamofire
import SwiftyJSON
import CoreLocation

class LocationAPI {
    static var shared = LocationAPI()
    private init() {}
    
    
    let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    
    func callRequest(lat: Double, lon: Double, completionHandler: @escaping (LocationInfomation) -> ()) {
        print(#function)
        
        let url = "\(APIURL.kakaoLocationURL)x=\(lat)&y=\(lon)&input_coord=WGS84"
       
        AF.request(url, method: .get, headers: header).validate().responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                //왜 안나오냐 ㅠ
                let addressName = json["documents"][0]["address_name"].stringValue
                print(addressName, "gggggggggg")
                
                completionHandler(LocationInfomation(addressName: addressName))
                
            case .failure(let error):
                print(error)
                
                
            }
        }
        
    }
}

