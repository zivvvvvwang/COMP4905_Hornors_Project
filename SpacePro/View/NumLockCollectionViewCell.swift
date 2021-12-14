//
//  NumLockCollectionViewCell.swift
//  SpacePro
//
//  Created by XiaorAx on 2021/10/10.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

enum NumLockCellStyle {
    case number(num: String)
    case delete(str: String)
    case clear(str: String)
}

class NumLockCollectionViewCell: UICollectionViewCell {
    
    lazy var btn = UIButton()
    lazy var label = UILabel()
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        btn.backgroundColor = UIColor.black
        contentView.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 62 * KSCALE / 2
        }
        
        
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = UIColor.white
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWith(_ style: NumLockCellStyle, handler: @escaping (() -> Void)){
        switch style {
        case .number(let num):
            label.text = num
        case .delete(let str):
            label.text = str
        case .clear(let str):
            label.text = str
        }
        
        btn.rx.tap.asObservable().subscribe(onNext: {
            handler()
        }).disposed(by: disposeBag)
    }
}
