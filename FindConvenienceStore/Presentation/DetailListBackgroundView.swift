//
//  DetailListBackgroundView.swift
//  FindConvenienceStore
//
//  Created by 김원기 on 2023/08/08.
//

import RxCocoa
import RxSwift
import SnapKit

//  DetailList가 아무런 정보를 받아오지 못할 경우 리스트에 아무것도 표시하지 않을때 BackgroundView를 동적으로 표시

class DetailListBackgroundView: UIView {
    let disposeBag = DisposeBag()
    let statusLabel = UILabel()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel:DetailListBackgroundViewModel) {
        viewModel.isStatusLabelHidden
            .emit(to: statusLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        backgroundColor = .white
        
        statusLabel.text = "🏪"
        statusLabel.textAlignment = .center
    }
    
    private func layout() {
        addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    //  rootViewModel에서 바인딩
}
