//
//  GuestSession.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 8/10/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

class GuestSessionResponse: Decodable {
    var success: Bool = false
    var guest_session_id: String?
    var expires_at: String?
}
