//
//  AddAlbumVC.swift
//  SpacePro
//
//  Created by Ziwen Wang on 2021/10/10.
//

import Foundation
import UIKit
import RxSwift

protocol DataProtocol {
    var is_public: Bool { get }
}

struct Album: Codable, DataProtocol {
    let id:String
    let name: String
    let isPublic: Bool
    
    enum CodingKeys: String, CodingKey {
        case name, isPublic, id
    }
    
    var is_public: Bool {
        return isPublic
    }
}

class AddAlbumVC: UIViewController {
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "enter album name"
        textField.backgroundColor = .lightGray
        return textField
    }()
    
    lazy var switcher: UISwitch = {
        let switcher = UISwitch()
        return switcher
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("Cancel", for: .normal)
        return btn
    }()
    
    lazy var confirmBtn: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("Confirm", for: .normal)
        return btn
    }()
    
    let disposeBag = DisposeBag()
    let type: MenuType
    let idx: Int
    
    init(type: MenuType, idx: Int) {
        self.type = type
        self.idx = idx
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(confirmBtn)
        view.addSubview(textField)
        view.addSubview(switcher)
        view.addSubview(closeBtn)
        
        closeBtn.snp.makeConstraints { make in
            make.left.top.equalTo(20)
        }
        
        confirmBtn.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.right.equalTo(-20)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(100)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        let label = UILabel()
        label.textColor = .black
        label.text = "is public"
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(textField.snp.bottom).offset(20)
        }
        switcher.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.right.equalTo(-20)
        }
        
        closeBtn.rx.tap.asObservable().subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        confirmBtn.rx.tap.asObservable().subscribe(onNext: { [weak self] in
            guard let self = self else {return}
            CacheManager.shared.addAlbum(Album(id: "\(Date().timeIntervalSince1970)", name: self.textField.text ?? "", isPublic: self.switcher.isOn), type: self.type)
            let homeVC = self.presentingViewController as? HomeVC
            homeVC?.menus[self.idx].models = CacheManager.shared.getAlbums(type: self.type)
            homeVC?.collectionView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        switch type {
        case .album:
            textField.placeholder = "Enter the album name"
        case .video:
            textField.placeholder = "Enter rge video name"
        case .file:
            textField.placeholder = "Enter the file name"
        default:
            break
        }
    }
}
