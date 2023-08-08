//
//  LocationInfoViewController.swift
//  FindConvenienceStore
//
//  Created by 김원기 on 2023/08/07.
//

import UIKit
import RxCocoa
import RxSwift
import CoreLocation
import SnapKit

class LocationInfoViewController: UIViewController {
    let disposeBag = DisposeBag() // bind 함수를 만들때 rx코드 정의
    
    let locationManager = CLLocationManager()
    let mapView = MTMapView()
    let detailList = UITableView()
    let currentLocationButton = UIButton()
    let viewModel = LocationInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        bind(viewModel)
        attribute()
        layout()
    }
    
    private func bind(_ viewModel: LocationInfoViewModel) {
        //  viewModel 바인딩 과정
        viewModel.setMapCenter
            .emit(to: mapView.rx.setMapCenterPoint)
            .disposed(by: disposeBag)
        
        //  에러 메시지 연결, alert컨트롤러 생성
        viewModel.errorMessage
            .emit(to: self.rx.presentAlert)
            .disposed(by: disposeBag)
        
        currentLocationButton.rx.tap
            .bind(to: viewModel.currentLocationButtonTapped)
            .disposed(by: disposeBag)
    }
    
    func attribute() {
        title = "내 주변 편의점 찾기"
        view.backgroundColor = .white
        
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        
        currentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        currentLocationButton.backgroundColor = .white
        currentLocationButton.layer.cornerRadius = 20
    }
    
    func layout() {
        [mapView, currentLocationButton, detailList]
            .forEach{ view.addSubview($0) }
        
        mapView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.centerY).offset(100)
        }
        
        detailList.snp.makeConstraints {
            $0.centerX.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.top.equalTo(mapView.snp.bottom)
        }
        
        currentLocationButton.snp.makeConstraints {
            $0.bottom.equalTo(detailList).offset(-12)
            $0.leading.equalToSuperview().offset(12)
            $0.width.height.equalTo(40)
        }
    }
}


//  MARK: - Delegate 설정
//  MARK: CLLocationManagerDelegate
extension LocationInfoViewController: CLLocationManagerDelegate {
    func locationManager(_ manager:CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        switch status {
        case .authorizedAlways,
             .authorizedWhenInUse,
             .notDetermined:
            return
        default:
            viewModel.mapViewError.accept(MTMapViewError.locationAuthorizationDenied.errorDescription)
            return
        }
    }
}

//  MARK: MTMapViewDelegate
extension LocationInfoViewController: MTMapViewDelegate {
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        // 디버그, 시뮬레이터 모드의 경우 임의의 좌표값을 입력
        #if DEBUG
        viewModel.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.46319, longitude: 126.70078)))
        #else
        viewModel.currentLocation.accept(location)
        #endif
    }
    
    //  맵의 이동이 끝났을 때 센터 포인트 전송
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    //  핀 표시 아이템 탭할 경우
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        viewModel.selectPOIItem.accept(poiItem)
        return false
    }
    
    //  제대로된 현재 위치를 불러오지 못한 경우 오류 처리
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
        viewModel.mapViewError.accept(error.localizedDescription)
    }
    
}

//  MARK: -mapView에 center값을 생성
extension Reactive where Base: MTMapView {
    var setMapCenterPoint: Binder<MTMapPoint> {
        return Binder(base) { base, point in
            //  MTMapView에서 활용되는 setMapCenter를 rxExtension으로 커스텀
            base.setMapCenter(point, animated: true)
        }
    }
}

//  MARK: - alertController
extension Reactive where Base: LocationInfoViewController {
    var presentAlert: Binder<String> {
        return Binder(base) { base, message in
            let alertController = UIAlertController(title: "문제 발생", message: message, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            alertController.addAction(action)
            
            base.present(alertController, animated: true,
            completion:  nil)
        }
    }
}
