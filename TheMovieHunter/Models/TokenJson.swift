//
//  Token.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 8/15/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

class TokenJson: Decodable {
    var success: Bool = false
    var expires_at: String? = nil
    var request_token: String? = nil
}
