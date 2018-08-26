//
//  GeolocationViewController.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/08/18.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import UIKit
import CoreLocation
import RxSwift
import RxCocoa

private extension Reactive where Base: UILabel {
    /*
     Binder: 以下抜粋
     http://blog.a-azarashi.jp/entry/2018/01/13/222537
     そもそもBindToをどうやって実現しているのか本家ソースコードを除くと一目瞭然で Binder というコンポーネントを利用すれば良いことがわかりました。
     ObservableのbindにBinderを渡してやることで他のUIViewと同様，自動的にsubscribeしてくれます。
     
     http://toshi0383.hatenablog.com/entry/2016/08/22/210124
     RxSwiftにはbindToが大きく分けて2種類あります。
     引数にobserverを取るものと、binderを取るものです。 引数にvariableを取るものは基本observableを取るものと動きが同じです。
     */
    var coordinate: Binder<CLLocationCoordinate2D> {
        return Binder(base) { label, location in
            label.text = "Lat: \(location.latitude)\nLon:\(location.longitude)"
        }
    }
}

class GeolocationViewController: ViewController {

    @IBOutlet var noGeolocationView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var label: UILabel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.noGeolocationView)
        let geolocationService = GeolocationService.instance
        
        /*
         https://qiita.com/k5n/items/44ef2ab400f47fb66731
         Driver に変換すると、
           ・メインスレッドで通知
           ・shareReplayLatestWhileConnected を使った Cold-Hot 変換
           ・エラー処理
         をやってくれます。
         利用側では subscribe や bindTo でなく drive を使います。drive メソッドは Driver にしかないので、
         buttonTitle(リンク内例) が Driver でなく単なる Observable だったらコンパイルエラーになります。
         */
        
        //authorized: Driver<Bool>
        geolocationService.authorized
            .drive(self.noGeolocationView.rx.isHidden)
            .disposed(by: self.disposeBag)
        
        //location: Driver<CLLocationCoordinate2D>
        geolocationService.location
            .drive(self.label.rx.coordinate)
            .disposed(by: self.disposeBag)
        
        button.rx.tap
            .bind { [weak self] _ -> Void in
                self?.openAppPreferences()
            }
            .disposed(by: self.disposeBag)
        
        button2.rx.tap
            .bind { [weak self] _ -> Void in
                self?.openAppPreferences()
            }
            .disposed(by: self.disposeBag)
    }
    
    private func openAppPreferences() {
        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
