//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Tareq Mia on 12/14/22.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var themeStore = ThemeStore(named: "Default")
    var body: some Scene {
        WindowGroup {
            ThemeChooser()
                .environmentObject(themeStore)
        }
    }
}
