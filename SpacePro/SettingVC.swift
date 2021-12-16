//
//  SettingVC.swift
//  SpacePro
//
//  Created by Ziwen Wang on 2021/11/13.
//

import Foundation
import UIKit

class SettingVC: UIViewController {
    var settings = ["Reset public password", "Reset private password", "about"]
    lazy var cancelIcon: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: 50, width: 0, height: 30))
        btn.setTitle("back", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        btn.sizeToFit()
        return btn
    }()
    
    lazy var titleView: UILabel = {
        let label = UILabel()
        label.text = "Setting"
        label.textColor = .black
        return label
    }()
    
    lazy var menuView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 90, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 100), style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
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
        menuView.backgroundColor = .white
        
        view.addSubview(cancelIcon)
        view.addSubview(titleView)
        view.addSubview(menuView)
        
        titleView.snp.makeConstraints { make in
            make.centerY.equalTo(cancelIcon)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}


extension SettingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .white
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = settings[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = EnterPasswordVC(type: .reset_public)
            present(vc, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let vc = EnterPasswordVC(type: .reset_private)
            present(vc, animated: true, completion: nil)
        } else if indexPath.row == 2 {
            let vc = AboutVC()
            present(vc, animated: true, completion: nil)
        }
    }
}
