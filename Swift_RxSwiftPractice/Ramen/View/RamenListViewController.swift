//
//  RamenListViewController.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/07/13.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RamenListViewController: UIViewController {

    @IBOutlet weak var ramenListTabreView: UITableView!
    let disposeBag = DisposeBag()
    //ViewModel層から表示するラーメンデータの取得
    let ramenViewModel = RamenViewModel()
    //データソースの定義
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Ramen>>(
        //データソースを元にしてセルの生成を行う
        configureCell: { (_, tableView, indexPath, ramens) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = ramens.name
            cell.detailTextLabel?.text = ramens.taste
            cell.imageView?.image = ramens.image
            return cell
        },
        //データソースを元にしてセクションの生成を行う
        titleForHeaderInSection: { dataSouce, sectionIndex in
            return dataSouce[sectionIndex].model
        }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //作成したデータと表示するUITableViewをBindする
        self.ramenViewModel.ramens
            .bind(to: self.ramenListTabreView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        //RxSwiftを利用してUITableViewDelegateを適用
        self.ramenListTabreView.rx
            .setDelegate(self)
            .disposed(by: self.disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension RamenListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}
