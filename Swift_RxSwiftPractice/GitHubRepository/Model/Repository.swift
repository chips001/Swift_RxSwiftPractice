//
//  RepositoryModel.swift
//  Swift_RxSwiftPractice
//
//  Created by 一木 英希 on 2018/07/17.
//  Copyright © 2018年 一木 英希. All rights reserved.
//

import ObjectMapper

class Repository: Mappable {
    var identifier: Int!
    var html_url: String!
    var name: String!
    
    required init?(map: Map){}
    
    func mapping(map: Map){
        self.identifier <- map["id"]
        self.html_url <- map["html_url"]
        self.name <- map["name"]
    }
}
