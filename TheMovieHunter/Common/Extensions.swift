//
// Created by ws-016-11b on 13.09.2018.
// Copyright (c) 2018 ws-013-11b. All rights reserved.
//

import Foundation
import UIKit

extension UIRefreshControl {
    func programaticallyBeginRefreshing(in tableView: UITableView) {
        beginRefreshing()
        let offsetPoint = CGPoint.init(x: 0, y: tableView.contentOffset.y-frame.size.height)
        tableView.setContentOffset(offsetPoint, animated: true)
    }
}
