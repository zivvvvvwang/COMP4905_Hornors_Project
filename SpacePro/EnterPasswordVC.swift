//
//  EnterPasswordVC.swift
//  SpacePro
//
//  Created by Ziwen Wang on 2021/10/10.
//

import UIKit
import SnapKit
let KSCALE = UIScreen.main.bounds.size.width/375

enum PasswordType {
    case set_public_password
    case confirm_public_password(lastPassword: String)
    case enter_password(publicPassword: String, privatePassword: String, isPublic: Bool, isBack: Bool)
    case confirm_private_password(publicPassword:String, lastPassword: String)
    case set_private_password(publicPassword:String)
    case reset_public
    case reset_private
    
    func getTitle() -> String{
        switch self {
        case .set_public_password:
            return "Set public password"
        case .confirm_public_password:
            return "Confirm public password"
        case .enter_password:
            return "Enter password"
        case .set_private_password:
            return "Set private password"
        case .confirm_private_password:
            return "Confirm private password"
        case .reset_public:
            return "Reset public password"
        case .reset_private:
            return "Reset private password"
        }
    }
}
class EnterPasswordVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    var numViews: [UILabel] = []
    var currentIdx: Int = 0
    let type: PasswordType
    var currentPassword: [String] = ["","","","","",""]
    
    init(type: PasswordType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        initHeader()
        initNumLockKeyboard()
        // Do any additional setup after loading the view.
    }
    
    func initHeader(){
        let name = UILabel()
        name.text = type.getTitle()
        name.textAlignment = .center
        name.font = UIFont.systemFont(ofSize: 24)
        name.sizeToFit()
        name.textColor = UIColor.black
        self.view.addSubview(name)
        name.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(88)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
        
        let pointView = UIStackView()
        pointView.axis = .horizontal
        pointView.alignment = .fill
        pointView.spacing = 25
        pointView.distribution = .fillEqually
        self.view.addSubview(pointView)
        pointView.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(UIScreen.main.bounds.size.width/6 - 27)
        }
        
        for _ in 0...5 {
            let label = UILabel()
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.black.cgColor
            label.textColor = .black
            label.textAlignment = .center
            numViews.append(label)
            
            pointView.addArrangedSubview(label)
        }
    }
    func initNumLockKeyboard(){
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize(width: 62 * KSCALE, height: 62 * KSCALE)
        flowLayout.minimumLineSpacing = 20 * KSCALE
        flowLayout.sectionInset = UIEdgeInsets(top: 20 * KSCALE, left: 60 * KSCALE, bottom: 0, right: 60 * KSCALE)
        let collection = UICollectionView.init(frame: CGRect(x: 0, y: 400, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-400), collectionViewLayout: flowLayout)
        collection.backgroundColor = .white
        collection.register(NumLockCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "NumLockCollectionViewCell")
        collection.dataSource = self
        self.view.addSubview(collection)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NumLockCollectionViewCell", for: indexPath) as? NumLockCollectionViewCell
        if indexPath.row < 9 {
            cell?.setupWith(.number(num: "\(indexPath.row+1)")) { [weak self] in
                self?.clickNumber(num: indexPath.row+1)
            }
        } else if indexPath.row == 9 {
            cell?.setupWith(.delete(str: "delete")) { [weak self] in
                self?.clickDelete()
            }
        } else if indexPath.row == 10 {
            cell?.setupWith(.number(num: "0")) { [weak self] in
                self?.clickNumber(num: 0)
            }
        } else if indexPath.row == 11 {
            cell?.setupWith(.clear(str: "clear")) { [weak self] in
                self?.clickClear()
            }
        }
        return cell!
    }
    
    func clickNumber(num: Int) {
        numViews[currentIdx].text = "*"
        currentPassword[currentIdx] = "\(num)"
        if (currentIdx == 5) {
            switch type {
            case .set_public_password:
                present(EnterPasswordVC(type: .confirm_public_password(lastPassword: currentPassword.joined(separator: ""))), animated: true, completion: nil)
            case .confirm_public_password(let last):
                if (last == currentPassword.joined(separator: "")) {
                    present(EnterPasswordVC(type: .set_private_password(publicPassword: currentPassword.joined())), animated: true, completion: nil)
                }
            case .enter_password(let pub, let pri, let isPublic, let isBack):
                if isPublic {
                    if pub == currentPassword.joined(separator: "") {
                        if isBack {
                            let homeVC = presentingViewController as? HomeVC
                            dismiss(animated: true) { [weak homeVC] in
                                homeVC?.refresh()
                            }
                        } else {
                            present(HomeVC(isPublic: true), animated: true, completion: nil)
                        }
                    }
                } else {
                    if pri == currentPassword.joined(separator: "") {
                        let homeVC = presentingViewController as? HomeVC
                        dismiss(animated: true) { [weak homeVC] in
                            homeVC?.refresh()
                        }
                    }
                }
                
            case .set_private_password(let pub):
                present(EnterPasswordVC(type: .confirm_private_password(publicPassword: pub, lastPassword: currentPassword.joined(separator: ""))), animated: true, completion: nil)
            case .confirm_private_password(let pub, let last):
                if (last == currentPassword.joined(separator: "")) {
                    UserDefaults.standard.set(pub, forKey: "public_password")
                    UserDefaults.standard.set(last, forKey: "private_password")
                    present(HomeVC(isPublic: true), animated: true, completion: nil)
                }
            case .reset_public:
                UserDefaults.standard.set(currentPassword.joined(), forKey: "public_password")
                dismiss(animated: true, completion: nil)
            case .reset_private:
                UserDefaults.standard.set(currentPassword.joined(), forKey: "private_password")
                dismiss(animated: true, completion: nil)
            }
        } else {
            currentIdx+=1
        }
    }
    
    func clickDelete() {
        numViews[currentIdx].text = ""
        currentPassword[currentIdx] = ""
        currentIdx = max(0, currentIdx-1)
        
    }
    
    func clickClear() {
        numViews.forEach { label in
            label.text = ""
        }
        currentIdx = 0
        currentPassword = ["","","","","",""]
    }
}
