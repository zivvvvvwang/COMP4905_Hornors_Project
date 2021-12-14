//
//  HomeVC.swift
//  SpacePro
//
//  Created by XiaorAx on 2021/10/10.
//

import Foundation
import UIKit

enum MenuType: String {
    case album
    case video
    case file
    case note
    case number
    case setting
}

struct Media: Codable {
    let url: URL
    let data: Data
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case url, data, name
    }
}

struct HomeMenu {
    let title: String
    var models: [DataProtocol]
    let isPrivate: Bool
    let type: MenuType
}

class HomeVC: UIViewController {
    var currentSelect: Int = 0
    var menus: [HomeMenu] = [
        HomeMenu(title: "Album", models: CacheManager.shared.getAlbums(type: .album), isPrivate: false, type: .album),
        HomeMenu(title: "Video", models: CacheManager.shared.getAlbums(type: .video), isPrivate: false, type: .video),
        HomeMenu(title: "File", models: CacheManager.shared.getAlbums(type: .file), isPrivate: false, type: .file),
        HomeMenu(title: "Note", models: CacheManager.shared.getNotes(), isPrivate: true, type: .note),
        HomeMenu(title: "Number", models: CacheManager.shared.getNumbers(), isPrivate: true, type: .number),
        HomeMenu(title: "Setting", models: [], isPrivate: false, type: .setting)
    ]
    var isPublic: Bool
    lazy var leftIcon: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: 50, width: 30, height: 30))
        btn.setImage(UIImage(named: "home"), for: .normal)
        btn.addTarget(self, action: #selector(goToPrivate), for: .touchUpInside)
        return btn
    }()
    
    lazy var rightIcon: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 60, y: 50, width: 30, height: 30))
        btn.setTitle("+", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(add), for: .touchUpInside)
        return btn
    }()
    
    lazy var menuView: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 90, width: 100, height: UIScreen.main.bounds.height - 100), style: UITableView.Style.plain)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    lazy var titleView: UILabel = {
        let label = UILabel()
        label.text = "Album"
        label.textColor = .black
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 100
        layout.itemSize = CGSize(width: width/2-10, height: width/2+10)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
       let collectionView = UICollectionView(frame: CGRect(x: 100, y: 90, width: width, height: UIScreen.main.bounds.height - 100), collectionViewLayout: layout)
        collectionView.register(FileCell.self, forCellWithReuseIdentifier: "album")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    init(isPublic: Bool) {
        self.isPublic = isPublic
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(rightIcon)
        view.addSubview(leftIcon)
        view.addSubview(menuView)
        view.addSubview(titleView)
        titleView.sizeToFit()
        titleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(leftIcon)
        }
        view.addSubview(collectionView)
        
    }
    
    func refresh() {
        if isPublic {
            leftIcon.setImage(UIImage(named: "home"), for: .normal)
        } else {
            leftIcon.setImage(UIImage(named: "lock"), for: .normal)
        }
        
        menuView.reloadData()
    }
    
    @objc func goToPrivate() {
        if isPublic {
            let vc = EnterPasswordVC(type: .enter_password(publicPassword: UserDefaults.standard.string(forKey: "public_password") ?? "", privatePassword: UserDefaults.standard.string(forKey: "private_password") ?? "", isPublic: false, isBack: true))
            present(vc, animated: true, completion: nil)
            self.isPublic = false
        } else {
            let vc = EnterPasswordVC(type: .enter_password(publicPassword: UserDefaults.standard.string(forKey: "public_password") ?? "", privatePassword: UserDefaults.standard.string(forKey: "private_password") ?? "", isPublic: true, isBack: true))
            present(vc, animated: true, completion: nil)
            self.isPublic = true
        }
    }
    
    @objc func add() {
        if currentSelect <= 2 {
            present(AddAlbumVC(type: menus[currentSelect].type, idx: currentSelect), animated: true, completion: nil)
        } else if currentSelect == 3{
            present(AddNoteVC(), animated: true, completion: nil)
        } else if currentSelect == 4{
            present(AddNumberVC(), animated: true, completion: nil)
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPublic {
            return menus.filter{$0.isPrivate == false}.count
        }
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tempMenus = menus
        if isPublic {
            tempMenus = menus.filter{$0.isPrivate == false}
        }
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = tempMenus[indexPath.row].title
        cell.isSelected = indexPath.row == currentSelect
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (isPublic && indexPath.row == 3) || (!isPublic && indexPath.row == 5) {
            present(SettingVC(), animated: true, completion: nil)
            return
        }
        var tempMenus = menus
        if isPublic {
            tempMenus = menus.filter{$0.isPrivate == false}
        }
        
        currentSelect = indexPath.row
        titleView.text = tempMenus[indexPath.row].title
        collectionView.reloadData()
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var models = menus[currentSelect].models
        if isPublic {
            models = menus[currentSelect].models.filter({$0.is_public})
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "album", for: indexPath) as! FileCell
        cell.setWithModel(models[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isPublic {
            return menus[currentSelect].models.filter({$0.is_public}).count
        }
        return menus[currentSelect].models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var models = menus[currentSelect].models
        if isPublic {
            models = menus[currentSelect].models.filter({$0.is_public})
        }
        if let album = models[indexPath.row] as? Album {
            let vc = AddImageVC(album: album, type: menus[currentSelect].type)
            present(vc, animated: true, completion: nil)
        } else if let note = models[indexPath.row] as? Note {
            let vc = NoteDetailVC(note: note)
            present(vc, animated: true, completion: nil)
        } else if let number = models[indexPath.row] as? Number {
            let vc = NumberDetailVC(number: number)
            present(vc, animated: true, completion: nil)
        }
    }
}
