//
//  AddNoteVC.swift
//  SpacePro
//
//  Created by Ziwen Wang on 2021/10/11.
//

import Foundation
import UIKit

struct Note: Codable, DataProtocol {
    let id:String
    let name: String
    let content: String
    
    var is_public: Bool = true
    
    enum CodingKeys: String, CodingKey {
        case name, content, id
    }
}


class AddNoteVC: UIViewController {
    lazy var saveIcon: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 60, y: 50, width: 0, height: 30))
        btn.setTitle("save", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(save), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    lazy var cancelIcon: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: 50, width: 0, height: 30))
        btn.setTitle("cancel", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    lazy var titleView: UILabel = {
        let label = UILabel()
        label.text = "Note"
        label.textColor = .black
        return label
    }()
    
    lazy var titleTextField: UITextField = {
        let view = UITextField(frame: CGRect(x: 20, y: 100, width: UIScreen.main.bounds.size.width - 40, height: 50))
        view.placeholder = "title"
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.textColor = .black
        return view
    }()
    
    lazy var contentTextField: UITextView = {
        let view = UITextView(frame: CGRect(x: 20, y: 170, width: UIScreen.main.bounds.size.width - 40, height: 500))
        view.backgroundColor = .lightGray
        view.textColor = .black
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
        view.addSubview(titleTextField)
        view.addSubview(contentTextField)
        
        titleView.snp.makeConstraints { make in
            make.centerY.equalTo(cancelIcon)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func save() {
        guard let title = titleTextField.text, let content = contentTextField.text, !title.isEmpty, !content.isEmpty else {
            return
        }
        CacheManager.shared.addnote(Note(id: "\(Date().timeIntervalSince1970)", name: title, content: content))
        let homeVC = self.presentingViewController as? HomeVC
        homeVC?.menus[3].models = CacheManager.shared.getNotes()
        homeVC?.collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
