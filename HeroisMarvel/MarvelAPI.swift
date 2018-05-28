//
//  MarvelAPI.swift
//  HeroisMarvel
//
//  Created by School Picture Dev on 25/05/18.
//  Copyright © 2018 Eric Brito. All rights reserved.
//

import Foundation
import SwiftHash
import Alamofire

class MarvelAPI {
    static private let basePath = "https://gateway.marvel.com/v1/public/characters"
    static private let privateKey =  "dedfeee6b1c7640c38302038a0883af394df5f0e"
    static private let publicKey =  "d661b19b7fe6f3d0c720f50fc312ce50"
    static private let limit = 50
    
    class func loadHeroes(name: String?, page: Int = 0, onComplete: @escaping (MarvelInfo?) -> Void) {
        let offset = page * limit
        var startsWith: String = ""
        if let name = name, !name.isEmpty {
            startsWith = "nameStartsWith=\(name.replacingOccurrences(of: " ", with: ""))"
        }
        let url = basePath + getCredentials() + "&offset=\(offset)&limit=\(limit)&\(startsWith)"
         print(url)
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data,
                let marvelInfo = try? JSONDecoder().decode(MarvelInfo.self, from: data),
                marvelInfo.code == 200 else {
                    onComplete(nil)
                    return
            }
            onComplete(marvelInfo)
        }
        
    }
    
    private class func getCredentials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(ts+privateKey+publicKey).lowercased()
        return "?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
    }
}
