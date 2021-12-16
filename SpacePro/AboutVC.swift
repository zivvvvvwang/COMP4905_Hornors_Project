//
//  AboutVC.swift
//  SpacePro
//
//  Created by Ziwen Wang on 2021/11/13.
//

import Foundation
import UIKit

class AboutVC: UIViewController {
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
        label.text = "About"
        label.textColor = .black
        return label
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
        
        view.addSubview(cancelIcon)
        view.addSubview(titleView)
        
        titleView.snp.makeConstraints { make in
            make.centerY.equalTo(cancelIcon)
            make.centerX.equalToSuperview()
        }
        
        let label = UILabel(frame: CGRect(x: 0, y: 100, width: 0, height: 30))
        label.textColor = .black
        label.text = "This is a app for saving your own files."
        view.addSubview(label)
        label.sizeToFit()
        
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
}
