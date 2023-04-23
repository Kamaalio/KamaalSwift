//
//  CoreDataScreen.swift
//  Example
//
//  Created by Kamaal M Farah on 27/04/2023.
//

import SwiftUI
import KamaalNavigation
import KamaalExtensions

struct CoreDataScreen: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)], animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationStack {
            List {
                if items.isEmpty {
                    EmptyItemsView(itemName: "items")
                }
                ForEach(items, id: \.id) { item in
                    StackNavigationLink(
                        destination: Screens.coreDataChild(parentID: item.id),
                        nextView: { screen in MainView(screen: screen) }
                    ) {
                        TimestampView(time: item.timestamp)
                            .foregroundColor(.accentColor)
                    }
                    .buttonStyle(.plain)
                }
                .onDelete(perform: deleteItem)
            }
            #if os(iOS)
            .toolbar { ToolbarItem(placement: .navigationBarTrailing) { AddButton(action: addItem) } }
            #else
            .toolbar { AddButton(action: addItem) }
            #endif
        }
    }

    private func deleteItem(_ indices: IndexSet) {
        for index in indices {
            do {
                try items[index].delete()
            } catch {
                print("error", error)
            }
        }
    }

    private func addItem() {
        let item = Item(context: viewContext)
        item.timestamp = Date()
        item.id = UUID()

        do {
            try viewContext.save()
        } catch {
            print("error", error)
            return
        }
    }
}

struct CoreDataChildScreen: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var children: [Child] = []
    @State private var parent: Item?

    let parentID: Item.ID

    var body: some View {
        List {
            if children.isEmpty {
                EmptyItemsView(itemName: "children")
            }
            ForEach(children, id: \.id) { item in
                TimestampView(time: item.timestamp)
            }
        }
        #if os(iOS)
        .toolbar { ToolbarItem(placement: .navigationBarTrailing) { AddButton(action: addChild) } }
        #else
        .toolbar { AddButton(action: addChild) }
        #endif
        .onAppear(perform: {
            let parent = try! Item.find(by: NSPredicate(format: "id = %@", parentID.nsString), from: viewContext)!
            children = parent.childrenArray
                .sorted(by: {
                    $0.timestamp.compare($1.timestamp) == .orderedDescending
                })
            self.parent = parent
        })
    }

    private func addChild() {
        let child = Child(context: viewContext)
        child.timestamp = Date()
        child.id = UUID()
        child.parent = parent!

        do {
            try parent!.addChild(child)
        } catch {
            print("error", error)
            return
        }

        withAnimation {
            children = [child] + children
        }
    }
}

struct EmptyItemsView: View {
    let itemName: String

    var body: some View {
        Text("No \(itemName) yet")
    }
}

struct TimestampView: View {
    let time: Date

    var body: some View {
        Text(dateFormatter.string(from: time))
    }
}

struct AddButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .bold()
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter
}()

struct CoreDataScreen_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataScreen()
    }
}
