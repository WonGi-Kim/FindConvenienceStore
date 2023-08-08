//
//  DetailListBackgroundViewModel.swift
//  FindConvenienceStore
//
//  Created by 김원기 on 2023/08/08.
//

import RxCocoa
import RxSwift

//  DetailList가 아무런 정보를 받아오지 못할 경우 리스트에 아무것도 표시하지 않을때 BackgroundView를 동적으로 표시

struct DetailListBackgroundViewModel {
    //  viewModel -> view
    let isStatusLabelHidden: Signal<Bool> //    리스트에 아무런 정보가 없을때 보이고 정보가 있다면 보여지도록
    
    //  외부에서 전달받을 값
    let shouldHideStatusLabel = PublishSubject<Bool>()
    init() {
        isStatusLabelHidden = shouldHideStatusLabel
            .asSignal(onErrorJustReturn: true)
    }
}
