//
//  LocationInfoViewModel.swift
//  FindConvenienceStore
//
//  Created by 김원기 on 2023/08/07.
//

import RxCocoa
import RxSwift

struct LocationInfoViewModel {
    let disposeBag = DisposeBag()
    let currentLocationButtonTapped = PublishRelay<Void>()
    
    //  MARK: - 옵저버를 통해 전달하기 위해 작성 (viewModel -> view)
    let setMapCenter: Signal<MTMapPoint>
    let errorMessage: Signal<String>
    
    //  api통신을 통해 받아와 테이블 뷰에 뿌려준다.
    let detailListCellData: Driver<[DetailCellData]>
    
    //  mapView에서 특정한 포인트를 눌렀을 때 리스트에 어떤 편의점인지 표시
    let scrollToSelectedLocation: Signal<Int>
    
    //  MARK: - view의 delegate를 전달 (view -> viewModel)
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError = PublishRelay<String>()
    
    //  리스트가 선택되었을 때 전달되는 row값
    let detailListItemSelected = PublishRelay<Int>()
    
    //  documentData는 KLDocument값을 리스트로 받는다.
    //  추후에 api로 받는 값을 cell에 뿌리기 위해
    let documentData = PublishSubject<[KLDocument?]>()
    
    //  MARK: - 지도 중심점 설정
    init() {
        
        //  값이 전달되면 x,y 값을 Double로 변경
        //  해당 값은 중심점 설정의 merge에 추가한다.
        let selectDetailListItem = detailListItemSelected
            .withLatestFrom(documentData) { $1[$0] }
            .map { data -> MTMapPoint in
                guard let data = data,
                      let longtitude = Double(data.x),
                      let latitude = Double(data.y) else {
                    return MTMapPoint()
                }
                let geoCoord = MTMapPointGeo(latitude: latitude, longitude: longtitude)
                return MTMapPoint(geoCoord: geoCoord)
            }
        
        //  현재 위치 버튼을 눌렀을 때 이동
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation)
        
        let currentMapCenter = Observable
            .merge(
                selectDetailListItem,
                //  최초로 currentLocation을 받았을 때 한번
                currentLocation.take(1),
                moveToCurrentLocation
            )
        
        //  viewModel에서 view로 전달되어야 하는 시그널 생성, 다시 바인딩 과정 필요 (viewController 에서)
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        errorMessage = mapViewError.asObservable()
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요.")
        
        detailListCellData = Driver.just([])
        
        scrollToSelectedLocation = selectPOIItem
            .map { $0.tag }
            .asSignal(onErrorJustReturn: 0)
    }
    
    //  MARK: - SubViewModels
    
    
}
