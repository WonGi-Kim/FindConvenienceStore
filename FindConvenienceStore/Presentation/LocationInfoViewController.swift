//
//  LocationInfoViewController.swift
//  FindConvenienceStore
//
//  Created by 김원기 on 2023/08/07.
//

import UIKit
import RxSwift
import RxCocoa
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
        
        bind(viewModel)
        attribute()
        layout()
    }
    
    func bind(_ viewModel: LocationInfoViewModel) {
        currentLocationButton.rx.tap
            .bind(to: viewModel.currentLocationButtonTapped)
            .dispose(by: disposeBag)
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
