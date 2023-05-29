//
//  ThemeChooser.swift
//  Memorize
//
//  Created by Tareq Mia on 5/28/23.
//

import SwiftUI

struct ThemeChooser: View {

    @EnvironmentObject var store: ThemeStore
    @State private var games = [Theme: EmojiMemoryGame]()
    @State private var themeToEdit: Theme?
    @State private var editMode: EditMode = .inactive
    
    var body: some View {

        NavigationView {
            List {
                ForEach(store.themes) { theme in
                    NavigationLink(destination: getDestination(for: theme)) {
                        themeRow(for: theme)
                    }
                    .gesture(editMode == .active ? openThemeEditor(for: theme) : nil)
                }
                .onMove(perform: { fromOffsets, toOffset in
                    store.themes.move(fromOffsets: fromOffsets, toOffset: toOffset)
                })
                .onDelete { indexSet in
                    indexSet.forEach({ store.removeTheme(at: $0) })
                }
                

            }
            .listStyle(.inset)
            .navigationTitle("Memorize")
            .sheet(item: $themeToEdit) {
                removeNewThemeOnDismissIfInvalid()
            } content: { theme in
                ThemeEditor(theme: $store.themes[theme])
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        store.insertTheme(named: "New", emojis: "")
                        self.themeToEdit = store.themes.first
                        
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem {
                    EditButton()
                }
            }
            .environment(\.editMode, $editMode)
        }

    }

    private func getDestination(for theme: Theme) -> some View {
        if games[theme] == nil {
            let newGame = EmojiMemoryGame(theme: theme)
            games.updateValue(newGame, forKey: theme)
            return EmojiMemoryGameView(game: newGame, theme: theme)
        }

        return EmojiMemoryGameView(game: games[theme]!, theme: theme)
    }

    private func themeRow(for theme: Theme) -> some View {
        VStack(alignment: .leading) {
            Text(theme.name)
                .foregroundColor(Color(red: theme.color.red, green: theme.color.green, blue: theme.color.blue))
                .font(.system(size: 25))
                .bold()
            HStack {
                if theme.numberOfPairsOfCards == theme.emojis.count {
                    Text("All of \(theme.emojis)")
                } else {
                    Text("\(String(theme.numberOfPairsOfCards)) pairs from \(theme.emojis)")
                }
            }.lineLimit(1)
        }
    }
    
    private func removeNewThemeOnDismissIfInvalid() {
        if let newTheme = store.themes.first {
            if newTheme.emojis.count < 2 {
                store.removeTheme(at: 0)
            }
        }
    }
    
    private func openThemeEditor(for theme: Theme) -> some Gesture {
        TapGesture()
            .onEnded {
                themeToEdit = store.themes[theme]
            }
    }
}
