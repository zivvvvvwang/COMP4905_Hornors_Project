//
//  ImageDetailVC.swift
//  SpacePro
//
//  Created by XiaorAx on 2021/11/11.
//

import Foundation
import UIKit

class ImageDetailVC: UIViewController {
    
    let model:Media
    
    init(model: Media) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var leftIcon: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: 50, width: 30, height: 30))
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(exit), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(leftIcon)
        
        let imageView = UIImageView(image: UIImage(data: model.data))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.size.width)
        }
    }
    
    @objc func exit() {
        dismiss(animated: true, completion: nil)
    }
}
