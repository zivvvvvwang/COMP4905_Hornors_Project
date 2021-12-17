//
//  AddNumberVC.swift
//  SpacePro
//
//  Created by Ziwen Wang on 2021/11/11.
//

import Foundation
import UIKit


struct Number: Codable, DataProtocol {
    var type: String
    var values: [String]
    var id:String
    
    var is_public: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case type, id, values
    }
}

class AddNumberVC: UIViewController {
    
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
        btn.setTitle("save", for: .normal)
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
    
    lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    
    init() {
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
        view.addSubview(pickerView)
        view.addSubview(stackView)
        
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
        
        pickerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(200)
            make.bottom.equalTo(-20)
        }
        
        refresh(index: 0)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
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
        
        CacheManager.shared.addNumber(Number(type: subtitleView.text ?? "", values: textFields.compactMap({ textfield in
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
    
    func refresh(index: Int) {
        subtitleView.text = menus[index]
        
        stackView.arrangedSubviews.forEach({$0.removeFromSuperview()})
        
        map[menus[index]]?.forEach({ str in
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

extension AddNumberVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return menus.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return menus[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        refresh(index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 200
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 13)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = menus[row]
        pickerLabel?.textColor = .black
        return pickerLabel!
    }
}
