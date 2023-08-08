//
//  DetailListCell.swift
//  FindConvenienceStore
//
//  Created by 김원기 on 2023/08/08.
//

import UIKit
import SnapKit

//  MARK: UITableView에 적절한 API통신을 통해 리스트에 셀을 올릴 수 있도록

class DetailListCell: UITableViewCell {
    let placeNameLabel = UILabel()
    let addressLabel = UILabel()
    let distanceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implementd")
    }
    
    //  미리 만들어둔 CellData를 받아옴
    func setData(_ data: DetailCellData) {
        placeNameLabel.text = data.placeName
        addressLabel.text = data.address
        distanceLabel.text = data.distance
    }
    
    private func attribute() {
        backgroundColor = .white
        placeNameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        
        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.textColor = .gray
        
        distanceLabel.font = .systemFont(ofSize: 12, weight: .light)
        distanceLabel.textColor = .darkGray
    }
    
    private func layout() {
        [placeNameLabel, addressLabel, distanceLabel]
            .forEach{ contentView.addSubview($0) }
        
        placeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(18)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(5)
            $0.leading.equalToSuperview().offset(18)
            $0.bottom.equalToSuperview().inset(12)
        }
        
        distanceLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
