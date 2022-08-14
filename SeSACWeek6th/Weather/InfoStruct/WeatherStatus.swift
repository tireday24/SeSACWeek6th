//
//  WeatherStatus.swift
//  SeSACWeek6th
//
//  Created by 권민서 on 2022/08/14.
//

import Foundation

enum WeatherStatus {
    static let thunderstorm = "Thunderstorm"
    static let drizzle = "Drizzle"
    static let rain = "Rain"
    static let snow = "Snow"
    static let atmosphere = "Atmosphere"
    static let clear = "Clear"
    static let clouds = "Clouds"
}

struct CurrentWeatherStatus {
    static func currentWeatherStatus(current: String) -> String {
        
        switch current {
        case WeatherStatus.thunderstorm:
            return "천둥 번개"
        case WeatherStatus.drizzle:
            return "안개"
        case WeatherStatus.rain:
            return "비"
        case WeatherStatus.snow:
            return "눈"
        case WeatherStatus.atmosphere:
            return "대기 기후"
        case WeatherStatus.clear:
            return "맑음"
        case WeatherStatus.clouds:
            return "구름 많음"
        default:
            return "날씨 정보 오류"
        }
    }
}

struct Message {
    static func weatherMessage(message: String) -> String {
        switch message {
        case WeatherStatus.thunderstorm:
            return " 천둥 번개가 예상돼요, 큰 소리가 나도 놀라지마세요!"
        case WeatherStatus.drizzle:
            return " 안개가 낄거에요, 가시거리를 확보해주세요. 안전운행 하시길 바랍니다!"
        case WeatherStatus.rain:
            return " 비가 내릴거라 예상돼요, 우산 꼭 챙기세요!"
        case WeatherStatus.snow:
            return " 눈이 올거라 예상돼요, 감기 조심하세요!"
        case WeatherStatus.atmosphere:
            return " 대기가 불안정해요, 집콕 필수입니다! 나가신다면 마스크 챙겨주세요!"
        case WeatherStatus.clear:
            return " 오늘 날씨가 맑아요, 밀린 빨래 부탁해요!"
        case WeatherStatus.clouds:
            return " 구름이 많을거라 예상됩니다, 우울해지지 않게 밝은 노래 들어주세요!"
        default:
            return " 데이터를 불러오지 못 했어요ㅠ"
        }
    }
}
