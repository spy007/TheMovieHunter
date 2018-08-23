//
//  SearchSettingsInteractor.swift
//  TheMovieHunter
//
//  Created by ws-013-11b on 8/23/18.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation

class SearchSettingsInteractor: SearchSettingsInteractorProtocol {
    
    private let mng: CoreDataManager
    
    init() {
        mng = CoreDataManager()
    }
    
    func getGenresDict() -> [Int:Genre]? {
        return mng.getGenresDict()
    }
}
