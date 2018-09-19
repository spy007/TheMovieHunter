//
//  AppDependecies.swift
//  TheMovieHunter
//
//  Created by ws-016-11b on 18.09.2018.
//  Copyright © 2018 ws-013-11b. All rights reserved.
//

import Foundation
import UIKit
import Dip
import Dip_UI

extension DependencyContainer {
    static func configure() -> DependencyContainer {
        return DependencyContainer() { container in
            unowned let container = container
            DependencyContainer.uiContainers = [container]
            container.register(tag: "MovieTableViewController") { MovieTableViewController() }
                    .resolvingProperties { container, controller in
                        controller.presenter = try container.resolve() as MovieTablePresenterProtocol
                    }
            container.register { MovieTablePresenter() as MovieTablePresenterProtocol}
        }
    }
}

extension MovieTableViewController: StoryboardInstantiatable { }
