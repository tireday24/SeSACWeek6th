//
//  WeatherViewController.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/14.
//

import UIKit
import CoreLocation

import Kingfisher


class WeatherViewController: UIViewController {
    
    
    @IBOutlet weak var currentTimeLable: UILabel!
    
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var currentLocationLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var feelLikeTempLabel: UILabel!
    @IBOutlet weak var mmTempLabel: UILabel!
    
    @IBOutlet weak var stateView: UIView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var hummidtyLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    //기본 좌표 - 청와대
    var latitude = 37.586580
    var longitude = 126.974884
    
    var currentTime = Timer()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        setUI()
        currentTimeSet()

    }
    
    func setUI() {
        tempView.backgroundColor = .clear
        stateView.backgroundColor = .clear
        messageView.backgroundColor = .clear
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.tintColor = .black
        reloadButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        reloadButton.tintColor = .black
        locationImageView.tintColor = .black
        
        currentTempLabel.layer.borderWidth = 2
        currentTempLabel.layer.cornerRadius = 5
        currentTempLabel.numberOfLines = 0
        feelLikeTempLabel.layer.borderWidth = 2
        feelLikeTempLabel.layer.cornerRadius = 5
        feelLikeTempLabel.numberOfLines = 0
        mmTempLabel.layer.borderWidth = 2
        mmTempLabel.layer.cornerRadius = 5
        mmTempLabel.numberOfLines = 0
        pressureLabel.layer.cornerRadius = 5
        pressureLabel.layer.borderWidth = 2
        pressureLabel.numberOfLines = 0
        hummidtyLabel.layer.cornerRadius = 5
        hummidtyLabel.layer.borderWidth = 2
        hummidtyLabel.numberOfLines = 0
        windLabel.layer.cornerRadius = 5
        windLabel.layer.borderWidth = 2
        windLabel.numberOfLines = 0
        messageLabel.layer.cornerRadius = 5
        messageLabel.layer.borderWidth = 2
        messageLabel.numberOfLines = 0
    }
    
    func currentTimeSet() {
        currentTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.currentTimeSetting), userInfo: nil, repeats: true)
    }
    
    @objc func currentTimeSetting() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM. dd(E) HH:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.locale = Locale(identifier: "ko")
        currentTimeLable.text = formatter.string(from: Date())
    }
    
}

extension WeatherViewController {
    
    func checkUserDeviceLocationServiceAuthorization() {
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        //위치 서비스 활성화 여부 체크
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
    
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            showRequestLocationServiceAlert()
            
            self.locationImageView.image = UIImage(systemName: "location.fill")
            
            LocationAPI.shared.callRequest(latitudinalMeters: latitude, longitudinalMeters: longitude) { location in
                //"\(location.region1), \(location.region2), \(location.region3)"
                self.currentLocationLabel.text = "\(location.addressName)"
            }
            
            WeatherAPI.shared.callRequest(lat: latitude, lon: longitude) { weather in
                self.currentTempLabel.text = "  현재 날씨는 \(CurrentWeatherStatus.currentWeatherStatus(current: weather.weatherName)), 현재 온도는 \(weather.temp)℃ 입니다"
                self.feelLikeTempLabel.text = "  현재 체감온도는 \(weather.feelLike)℃ 입니다"
                self.mmTempLabel.text = "  오늘 최고 온도는 \(weather.tempMax)℃로 예상됩니다. 오늘 최저 온도는 \(weather.tempMin)℃로 예상됩니다"
                
                self.hummidtyLabel.text = "  현재 습도는 \(weather.humidity)% 만큼 습합니다"
                self.windLabel.text = "  현재 풍속은 \(weather.wind)m/s 입니다"
                self.pressureLabel.text = "  현재 기압은 \(weather.pressure)atm 입니다"
                
                let iconURL = URL(string: APIURL.iconURL + "\(weather.icon)@2x.png")
                self.iconImage.kf.setImage(with: iconURL)
                
                self.messageLabel.text = Message.weatherMessage(message:weather.weatherName)
                
            }
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            locationManager.startUpdatingLocation()
            
        default: print("DEFAULT")
        }
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
        
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
          
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }

}

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            latitude = coordinate.latitude
            longitude = coordinate.longitude
            
            self.locationImageView.image = UIImage(systemName: "location.fill")
            
            LocationAPI.shared.callRequest(latitudinalMeters: latitude, longitudinalMeters: longitude) { location in
                //"\(location.region1), \(location.region2), \(location.region3)"
                self.currentLocationLabel.text = "\(location.addressName)"
            }
            
            WeatherAPI.shared.callRequest(lat: latitude, lon: longitude) { weather in
                self.currentTempLabel.text = "현재 날씨는 \(CurrentWeatherStatus.currentWeatherStatus(current: weather.weatherName)), 현재 온도는 \(weather.temp)℃ 입니다"
                self.feelLikeTempLabel.text = "현재 체감온도는 \(weather.feelLike)℃ 입니다"
                self.mmTempLabel.text = "오늘 최고 온도는 \(weather.tempMax)℃로 예상됩니다. 오늘 최저 온도는 \(weather.tempMin)℃로 예상됩니다"
                
                self.pressureLabel.text = "현재 습도는 \(weather.humidity)% 만큼 습합니다"
                self.windLabel.text = "현재 풍속은 \(weather.wind)m/s 입니다"
                self.pressureLabel.text = "현재 기압은 \(weather.pressure)atm 입니다"
                
                let iconURL = URL(string: APIURL.iconURL + "\(weather.icon)@2x.png")
                self.iconImage.kf.setImage(with: iconURL!)
                
                self.messageLabel.text = Message.weatherMessage(message:weather.weatherName)
                
            }
        }
        locationManager.stopUpdatingLocation()
    }



func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(#function)
}


func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    print(#function)
    checkUserDeviceLocationServiceAuthorization()
}

}

