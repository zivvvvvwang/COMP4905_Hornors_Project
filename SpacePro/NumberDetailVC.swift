//
//  NumberDetailVC.swift
//  SpacePro
//
//  Created by XiaorAx on 2021/11/13.
//

import Foundation
import UIKit

class NumberDetailVC: UIViewController {
    
    var offset:CGFloat = 0
    
    var menus: [String] = ["Credit Card", "Website password", "email", "height/weight"]
    var map:[String:[String]] = [
        "Credit Card":["Bank", "No", "ex date", "cvv", "password"],
        "Website password":["web name", "username", "password"],
        "email":["email address", "password"],
        "height/weight":["height(cm)", "weight(kg)"],
    ]
    
    lazy var saveIcon: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 60, y: 50+offset, width: 0, height: 30))
        btn.setTitle("modify", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(save), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    lazy var cancelIcon: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: 50+offset, width: 0, height: 30))
        btn.setTitle("cancel", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    lazy var deleteIcon: UIButton = {
        let btn = UIButton(frame: CGRect(x: 80, y: 50+offset, width: 0, height: 30))
        btn.setTitle("delete", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(mDelete), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    lazy var titleView: UILabel = {
        let label = UILabel()
        label.text = "Number"
        label.textColor = .black
        return label
    }()
    
    lazy var subtitleView: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()

    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.spacing = 10
        return view
    }()
    
    let number: Number
    init(number: Number) {
        self.number = number
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(saveIcon)
        view.addSubview(cancelIcon)
        view.addSubview(titleView)
        view.addSubview(subtitleView)
        view.addSubview(stackView)
        view.addSubview(deleteIcon)
        
        titleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(saveIcon)
        }
        
        subtitleView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(subtitleView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        set()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc func mDelete() {
        CacheManager.shared.deleteNumber(number)
        
        let homeVC = self.presentingViewController as? HomeVC
        homeVC?.menus[4].models = CacheManager.shared.getNumbers()
        homeVC?.collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func save() {
        var textFields = stackView.arrangedSubviews.compactMap { view in
            return view.subviews[1] as? UITextField
        }
        
        var temptextFields = textFields.filter({ textField in
            return textField.text?.isEmpty ?? true
        })
        
        if !temptextFields.isEmpty {
            return
        }
        
        CacheManager.shared.modifyNumber(Number(type: subtitleView.text ?? "", values: textFields.compactMap({ textfield in
            return textfield.text
        }), id: "\(Date().timeIntervalSince1970)"))
        
//        guard let title = titleTextField.text, let content = contentTextField.text, !title.isEmpty, !content.isEmpty else {
//            return
//        }
//        CacheManager.shared.addnote(Note(id: "\(Date().timeIntervalSince1970)", name: title, content: content))
        let homeVC = self.presentingViewController as? HomeVC
        homeVC?.menus[4].models = CacheManager.shared.getNumbers()
        homeVC?.collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func set() {
        subtitleView.text = number.type
        
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        
        var i = 0
        map[number.type]?.forEach({ str in
            let view = UIView()
            
            let label = UILabel()
            label.text = str
            label.textColor = .black
            label.sizeToFit()
            view.addSubview(label)
            
            let textfield = UITextField()
            textfield.layer.borderWidth = 1
            textfield.layer.borderColor = UIColor.black.cgColor
            textfield.textColor = .black
            view.addSubview(textfield)
            textfield.text = number.values[i]
            i+=1
            
            label.snp.makeConstraints { make in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(200)
            }
            
            textfield.snp.makeConstraints { make in
                make.left.equalTo(label.snp.right)
                make.right.top.bottom.equalToSuperview()
            }
            
            stackView.addArrangedSubview(view)
        })
    }
}
