//
//  ThemeEditor.swift
//  Memorize
//
//  Created by Tareq Mia on 5/28/23.
//

import SwiftUI

struct ThemeEditor: View {
    
    @Binding var theme: Theme
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var name: String = ""
    
    init(theme: Binding<Theme>) {
        self._theme = theme
        self._name = State(initialValue: theme.wrappedValue.name)
        self._numberOfPairsOfCards = State(initialValue: theme.wrappedValue.numberOfPairsOfCards)
        self._color = State(initialValue: Color(rgbaColor: theme.wrappedValue.color))
    }
    
    var body: some View {
        NavigationView {
            Form {
                nameSection
                addEmojisSection
                removeEmojisSection
                cardCountSection
                colorPickerSection
                
            }
            .navigationTitle("Edit \(theme.name)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton
                }
                ToolbarItem(placement: .confirmationAction) {
                    doneButton
                }
            }
        }
    }
    
    var nameSection: some View {
        Section(header: Text("Name")) {
            TextField("Name", text: self.$theme.name)
        }
    }
    
    @State private var emojisToAdd: String = ""
    
    var addEmojisSection: some View {
        Section("Add Emojis") {
            TextField("", text: $emojisToAdd)
                .onChange(of: emojisToAdd) { emojis in
                    addEmojis(emojis)
                }
        }
    }
    
    var removeEmojisSection: some View {
        Section(header: Text("Remove Emoji")) {
            let emojis = theme.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation {
                                theme.emojis.removeAll(where: { String($0) == emoji })
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
    
    @State private var numberOfPairsOfCards: Int
    
    var cardCountSection: some View {
        Section(header: Text("Number of Pairs")) {
            Stepper("\(numberOfPairsOfCards) Pairs", value: $numberOfPairsOfCards, in: theme.emojis.count < 2 ? 2...2: 2...theme.emojis.count )
                .onChange(of: theme.emojis) { _ in
                    numberOfPairsOfCards = max(2, numberOfPairsOfCards)
                }
            
        }
    }
    
    var cancelButton: some View {
        Button("Cancel") {
            if presentationMode.wrappedValue.isPresented {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    var doneButton: some View {
        Button("Done") {
            if presentationMode.wrappedValue.isPresented && theme.emojis.count > 2 {
                saveEdits()
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    @State private var color: Color
    
    var colorPickerSection: some View {
        Section(header: Text("Color")) {
            ColorPicker("Current Color", selection: $color, supportsOpacity: false)
                .onChange(of: color) { newColor in
                    theme.color = RGBAColor(color: newColor)
                }
        }
    }
    
    private func saveEdits() {
        theme.name = name
        theme.numberOfPairsOfCards = numberOfPairsOfCards
    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            theme.emojis = (emojis + theme.emojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
    
}

//struct ThemeEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        ThemeEditor()
//    }
//}
