//
//  App.swift
//  NetworkLayer
//
//  Created by Nithaparan Francis on 2022-06-09.
//

import Foundation

let App = AppConfig()

final class AppConfig {
    lazy var storage = Storage()
    struct Storage {
        lazy var authStore: AuthStorable = AuthStore()
    }
}
