//
//  FileCell.swift
//  SpacePro
//
//  Created by XiaorAx on 2021/10/10.
//

import Foundation
import UIKit

class FileCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
       let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = UIColor.black
        return label
    }()
    
    lazy var icon: UIImageView = {
        let view = UIImageView()
         return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(icon)
        
        imageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.left.equalToSuperview()
        }
        
        icon.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
            make.width.height.equalTo(20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWithModel(_ model:Any) {
        if let model = model as? Album {
            icon.isHidden = false
            titleLabel.text = model.name
            icon.image = model.isPublic ? UIImage(named: "home"):UIImage(named: "lock")
        } else if let model = model as? Note {
            titleLabel.text = model.name
            icon.isHidden = true
        }  else if let model = model as? Number {
            titleLabel.text = model.type
            icon.isHidden = true
        }
    }
}
