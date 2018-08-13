//
//  Ramen.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/07/11.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import UIKit
import RxDataSources

struct Ramen {
    let name: String
    let taste: String
    let imageId: String
    let image: UIImage
    
    init(name: String, taste: String, imageId: String) {
        self.name = name
        self.taste = taste
        self.imageId = imageId
        self.image = UIImage(named: imageId)!
    }
}

//既存の独自型(RxDataSourcesで定義されているIdentifiableType型)を拡張する
extension Ramen: IdentifiableType {
    typealias Identity = String
    var identity: Identity { return imageId }
}
