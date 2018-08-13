//
//  ImagePickerViewController.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/08/03.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImagePickerViewController: ViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var cropButton: UIButton!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        /*
         flatMapLatest
         flatMapFirstと同じくイベントをObservableに変換し、常に１つのObservableのイベントしか通知しないが、次のObservableが来ると
         そちらにスイッチする。
         ・Observable に変換
         ・常に一番新しい Observable を実行
         という動作。flatMapLatestは map + switchLatest と同じ動作である。
         */
        self.cameraButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                picker.sourceType = .camera
                picker.allowsEditing = false
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in return info[UIImagePickerControllerOriginalImage] as? UIImage }
            .bind(to: self.imageView.rx.image)
            .disposed(by: self.disposeBag)
        
        self.galleryButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                picker.sourceType = .photoLibrary
                picker.allowsEditing = false
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in return info[UIImagePickerControllerOriginalImage] as? UIImage }
            .bind(to: self.imageView.rx.image)
            .disposed(by: self.disposeBag)
        
        self.cropButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                }
                .flatMap { $0.rx.didFinishPickingMediaWithInfo }
                .take(1)
            }
            .map { info in return info[UIImagePickerControllerOriginalImage] as? UIImage }
            .bind(to: self.imageView.rx.image)
            .disposed(by: self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
