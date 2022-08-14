//
//  WeatherAPI.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/14.
//

import Foundation

import Alamofire
import SwiftyJSON

class WeatherAPI {
    static var shared = WeatherAPI()
    private init() {}
    
    
    func callRequest(lat: Double, lon: Double, completionHandler: @escaping (WeatherInfo) -> ()) {
        print(#function)
        
        let url = "\(APIURL.weatherURL)" + "lat=\(lat)&lon=\(lon)&appid=\(APIKey.openWeather)"

        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                let temp = Int(round(json["main"]["temp"].doubleValue - 273.15))
                let feelLike = Int(round(json["main"]["feelLike"].doubleValue - 273.15) * (-0.1))
                let tempMin = Int(round(json["main"]["temp_min"].doubleValue - 273.15))
                let tempMax = Int(round(json["main"]["temp_max"].doubleValue - 273.15))
                let pressure = json["main"]["pressure"].intValue
                let humidity = json["main"]["humidity"].intValue
                let wind = Int(round(json["wind"]["spped"].doubleValue * 10))
                let icon = json["weather"][0]["icon"].stringValue
                let weatherName = json["weather"][0]["main"].stringValue
                
                completionHandler(WeatherInfo(temp: temp, feelLike: feelLike, tempMin: tempMin, tempMax: tempMax, pressure: pressure, humidity: humidity, wind: wind, weatherName: weatherName, icon: icon))
                
               
                
            case .failure(let error):
                print(error)
                
                
            }
        }
        
    }

}
