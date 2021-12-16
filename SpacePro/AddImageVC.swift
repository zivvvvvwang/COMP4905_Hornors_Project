//
//  AddImageVC.swift
//  SpacePro
//
//  Created by Ziwen Wang on 2021/10/10.
//

import Foundation
import UIKit
import AVKit
import RxSwift

class AddImageVC: UIViewController {
    
    lazy var rightIcon: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 60, y: 50, width: 30, height: 30))
        btn.setTitle("+", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(add), for: .touchUpInside)
        return btn
    }()
    
    lazy var leftIcon: UIButton = {
        let btn = UIButton(frame: CGRect(x: 20, y: 50, width: 30, height: 30))
        btn.setImage(UIImage(named: "close"), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(exit), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleView: UILabel = {
        let label = UILabel()
        label.text = "Album"
        label.textColor = .black
        return label
    }()
    
    var datas:[Media]
    let album: Album
    let type: MenuType
    
    init(album: Album, type: MenuType) {
        self.album = album
        self.datas = CacheManager.shared.getMedias(in: album)
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width - 40
        layout.itemSize = CGSize(width: width/3-20, height: width/3)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
       let collectionView = UICollectionView(frame: CGRect(x: 20, y: 80, width: width, height: UIScreen.main.bounds.height - 50), collectionViewLayout: layout)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "image")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        view.addSubview(rightIcon)
        view.addSubview(leftIcon)
        view.addSubview(titleView)
        titleView.sizeToFit()
        titleView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(leftIcon)
        }
        switch type {
        case .album:
            titleView.text = "Album"
        case .video:
            titleView.text = "Video"
        case .file:
            titleView.text = "File"
        case .note:
            titleView.text = "Note"
        case .number:
            titleView.text = "Number"
        case .setting:
            break
        }
    }
    
    @objc func add() {
        switch type {
        case .album:
            let vc = UIImagePickerController()
            vc.mediaTypes = ["public.image"]
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        case .video:
            let vc = UIImagePickerController()
            vc.mediaTypes = ["public.movie"]
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        case .file:
            let documentTypes = ["public.content",
                                     "public.text",
                                     "public.source-code",
                                     "public.image",
                                     "public.audiovisual-content",
                                     "com.adobe.pdf",
                                     "com.apple.keynote.key",
                                     "com.microsoft.word.doc",
                                     "com.microsoft.excel.xls",
                                     "com.microsoft.powerpoint.ppt"]

            let document = UIDocumentPickerViewController.init(documentTypes: documentTypes, in: .open)
            document.delegate = self
            present(document, animated:true, completion:nil)
        default:
            break
        }
        
    }
    
    @objc func exit() {
        dismiss(animated: true, completion: nil)
    }
}

extension AddImageVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "image", for: indexPath) as? ImageCell
        cell?.setWithModel(datas[indexPath.row], handler: { [weak self] media in
            guard let self = self else {return}
            self.datas.remove(at: indexPath.row)
            CacheManager.shared.deleteMedia(in: self.album, index: indexPath.row)
            self.collectionView.reloadData()
        })
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == .video {
            let player = AVPlayer(url: datas[indexPath.row].url)
            let playerController = AVPlayerViewController()
            playerController.player = player
            self.present(playerController, animated: true) {
                player.play()

            }
        } else if type == .file {
            let vc = FileDetailVC(model: datas[indexPath.row])
            present(vc, animated: true, completion: nil)
        } else if type == .album {
            let vc = ImageDetailVC(model: datas[indexPath.row])
            present(vc, animated: true, completion: nil)
        }
    }
}

extension AddImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if type == .album {
            let image = info[.imageURL] as! URL
            if let data = try? Data(contentsOf: image) {
                let media = Media(url: image, data: data, name: image.lastPathComponent)
                datas.append(media)
                collectionView.reloadData()
                CacheManager.shared.addMedia(media, album)
            }
        } else if type == .video {
            let videoURL = info[.mediaURL] as! URL
            if let data = try? Data(contentsOf: videoURL) {
                let media = Media(url: videoURL, data: data, name: videoURL.lastPathComponent)
                datas.append(media)
                collectionView.reloadData()
                CacheManager.shared.addMedia(media, album)
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension AddImageVC: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let fileName = url.lastPathComponent
        if let data = try? Data(contentsOf: url) {
            let media = Media(url: url, data: data, name: fileName)
            datas.append(media)
            collectionView.reloadData()
            CacheManager.shared.addMedia(media, album)
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

class ImageCell: UICollectionViewCell {
    lazy var imageView: UIImageView = {
       let view = UIImageView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    lazy var icon: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "close_fill"), for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .lightGray
         return view
    }()
    
    lazy var titleView: UILabel = {
        let view = UILabel()
        view.textColor = .black
         return view
    }()
    
    var disposedBag = DisposeBag()
    
    var media:Media?
    var handler:((Media)->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(icon)
        contentView.addSubview(titleView)
        
        imageView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(-20)
        }
        
        icon.snp.makeConstraints { make in
            make.right.equalTo(-5)
            make.top.equalTo(5)
            make.width.height.equalTo(20)
        }
        
        titleView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        
        icon.rx.tap.asObservable().subscribe(onNext: { [weak self] in
            guard let media = self?.media else {
                return
            }

            self?.handler?(media)
        }).disposed(by: disposedBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposedBag = DisposeBag()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWithModel(_ model:Media, handler:@escaping (Media)->Void) {
        self.handler = handler
        imageView.image = UIImage(data: model.data)
        titleView.text = model.name
        titleView.sizeToFit()
        self.media = model
    }
}
