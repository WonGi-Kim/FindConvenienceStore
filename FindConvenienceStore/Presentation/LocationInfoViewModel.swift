//
//  LocationInfoViewModel.swift
//  FindConvenienceStore
//
//  Created by 김원기 on 2023/08/07.
//

import RxCocoa
import RxSwift

struct LocationInfoViewModel {
    let currentLocationButtonTapped = PublishRelay<Void>()
}
