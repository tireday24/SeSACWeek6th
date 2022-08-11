//
//  MapViewController.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/11.
//

import UIKit

import MapKit
//Location1. 임포트
import CoreLocation

/*
 MapView
 - 지도와 위치 권한은 상관X
 - 만약 지도에 현재 위치 등을 표현하고 싶다면 위치 권한을 등록해주어야 한다
 - 중심, 범위 지정
 - 핀(어노테이션)
 */

/*
 권한: 반영이 조금씩 느릴 수 있음 지웠다가 실행한다고 하더라도 한 번 허용
 설정: 앱이 바로 안 뜨는 경우도 있을 수 있음 뜨시는 분들은 설정 쪽에서 다음번에 묻기로 변경
 */

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    //Location2. 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location3. 프로토콜 연결
        locationManager.delegate = self
        
        //checkUserDeviceLocationServiceAuthorization() -> 제거 가능 CLLocationManager() 인스턴스 생성시 호출되기 때문에
        let center = CLLocationCoordinate2D(latitude: 37.524496, longitude: 127.035340)
        setRegionAndAnnotation(center: center)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showRequestLocationServiceAlert()
    }
    
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        //map -> 위치 검색 -> 점 3개 => 좌표 복사 37.524496, 127.035340
        //위도 경도 위치 정보를 가지고 올 때 위도 경도도 포함되지만 해수면 등호선 특정 기본 위치가 담겨져 있기 때문에 위도 경도 기준으로만 알고 싶어서 이런 형태
        
        //지역 범위 설정
        //2D 위도 경도가 포함된 정보
        //지도 중심 기반으로 보여질 범위 숫자가 크면 많이 보임
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        //위치 설정
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "도산공원 입니다"
        
        
        //핀 한개? 여러개?
        //지도에 핀 추가
        mapView.addAnnotation(annotation)
        
    }
}

//위치 관련된 User Defined 메서드
extension MapViewController {
    
    //Location7. iOS 버전에 따른 분기 처리 및 iOS 위치 서비스 활성화 여부 확인
    //위치 서비스가 켜져 있다면 권한을 요청하고, 꺼져 있다면 커스텀 얼럿으로 상황 알려주기
    // denied: 허용 안함 / 설정에서 추후에 거부 / 위치 서비스 중지 / 비행기 모드
    // restricted: 앱 권한 자체 없는 경우 / 자녀 보호 기능 같은걸로 아예 제한
    //notDetermined => 얼럿만 떠 있고 사용자가 안누르는 상태
    //
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            //인스턴스를 통해 locationManager가 가지고 있는 상태를 가져옴
            //문법 구조가 다르다
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        //iOS 위치 서비스 활성화 여부 체크
        if CLLocationManager.locationServicesEnabled() {
            //위치 서비스가 활성화 되어 있으므로, 위치 권한 요청 가능해서 위치 권한을 요청함
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
        
    }
    
    //Location8. 사용자의 위치 권한 상태 확인
    //사용자가 위치를 허용했는 지 거부했는 지 아직 선택하지 않았는지 등을 확인 (단, 사전에 iOS 위치 서비스 활성화 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("NOTDETERMINED")
            
            //기기에 맞게 정확도 맞춰 줌 kCLLocationAccuracyBest
            //어느 정도 위치가 바뀌면 호출 하기도 함
            //이미 정확도가 앱을 시작했을 때 정해짐
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //앱을 사용하는 동안 위치 권한 요청 메세지를 띄워주는 메서드 requestWhenInUseAuthorization
            locationManager.requestWhenInUseAuthorization() //얼럿 메세지 띄워주는 메서드
            //주의 plist WhenInUse -> request 매서드 OK
            //locationManager.startUpdatingLocation()
            
        case .restricted, .denied:
            print("DENIED, 아이폰 설정으로 유도")
            showRequestLocationServiceAlert()
            
        case .authorizedWhenInUse:
            print("WHEN IN USE")
            //사용자가 위치를 허용해둔 상태라면, startUpdatingLocation을 통해 didUpdateLocations 매서드가 실행
            locationManager.startUpdatingLocation() // 정확도를 위해서 무한대로 호출
        default: print("DEFAULT")
        }
    }
    
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
        
          //실제 설정으로 이동
          //설정까지 이동하거나 설정 세부화면까지 이동하거나
          //한번도 설정에 들어가지 않았거나 막 다운받은 앱이거나
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

//Location4. 프로토콜 선언
extension MapViewController: CLLocationManagerDelegate {
    
    //Location5. 사용자의 위치를 성공적으로 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        //ex. 위도 경도 기반으로 날씨 정보를 조회
        //ex. 지도를 다시 세팅
        //지도 갱신 마지막 정보 기준
        if let coordinate = locations.last?.coordinate {
//            let latitude = coordinate.latitude
//            let longtitude = coordinate.longitude
//            let center = CLLocationCoordinate2D(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)
            setRegionAndAnnotation(center: coordinate)
            
        }
       
        
        
        //위치 업데이트 멈춰!
        locationManager.stopUpdatingLocation()
    }
    
    //Location6. 사용자의 위치를 못 가지고 온 경우
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    //Location9. 사용자의 권한 상태가 바뀔 때를 알려줌
    //거부 했다가 설정에서 변경했거나 혹은 notDetermine에서 허용을 했거나
    //허용 했어서 위치를 가지고 오는 중에 설정에서 거부하고 돌아온다면?
    //iOS 14 이상: 사용자의 권한 상태가 변경이 될 때, 승인상태가 변경 됐을 때, 위치 관리자 생성할 때 호출 됨
    //locationManager 인스턴스 생성시 호출 -> viewDidload에서 한번 더 호출
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    
    //iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
}

extension MapViewController: MKMapViewDelegate {
    
    //지도에 커스텀 핀 추가
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        <#code#>
//    }
    
    //사용자가 지도 움직이다 멈추면 위치 지정됨 택시 오는거 보일때 지도 움직이고 도착지 변경하면 택시 위치 바뀜
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.startUpdatingLocation()
    }
    
}
