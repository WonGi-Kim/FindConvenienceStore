//
//  MTMapViewError.swift
//  FindConvenienceStore
//
//  Created by 김원기 on 2023/08/08.
//

import Foundation


//  LocationInfoViewController의 MTMapViewDelegate에서 오류처리 부분을 담당
enum MTMapViewError: Error {
    case failedUpdatingCurrentLocation
    case locationAuthorizationDenied
    
    var errorDescription: String {
        switch self {
        case.failedUpdatingCurrentLocation:
            return "현재 위치 불러오기에 실패했습니다."
        case.locationAuthorizationDenied:
            return "위치 정보를 비활성화하게 될 경우 사용자의 현재 위치를 불러올 수 없습니다."
        }
    }
}
