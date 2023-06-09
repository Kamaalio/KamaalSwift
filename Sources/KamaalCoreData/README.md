# KamaalCoreData

This package let's you easily create CoreData entities without the Xcode GUI used in the Data Model files.

## Installation

### Swift package manager

- Select File > Swift Packages > Add Package Dependency. Enter https://github.com/kamaalio/KamaalSwift.git in the "Choose Package Repository" dialog.

- In the next page, specify the version or a specific branch.

- After XCode checking out the source and resolving the version, you can choose the `KamaalCoreData` library and add it to your app target.

## Usage

For a quick overview checkout the example app in this repo.

### CoreData managed entity

```swift
import CoreData
import KamaalCoreData

@objc(Item) // class name available to Objective-C to manage.
public class Item: NSManagedObject, ManuallyManagedObject { // Using ManuallyManagedObject protocol.
    // CoreData managed properties.
    @NSManaged public var id: UUID
    @NSManaged public var timestamp: Date

    // Property representation for CoreData properties to use.
    public static let properties: [ManagedObjectPropertyConfiguration] = [
        ManagedObjectPropertyConfiguration(name: \Item.id, type: .uuid, isOptional: false),
        ManagedObjectPropertyConfiguration(name: \Item.timestamp, type: .date, isOptional: false),
    ]
}
```

### Registering managed entities

```swift
class PersistenceController {
    let container: NSPersistentContainer

    init() {
        let model = NSManagedObjectModel()
        model.entities = [
            Item.entity,
            // All your other managed object entities.
        ]
        container = NSPersistentContainer(name: "<ContainerName>", managedObjectModel: model)

        // All the other Persistence configurations.
    }
}
```

### Managed object API's

- Listing managed objects.

```swift
try Item.list(from: viewContext)
```

- Filtering managed objects.

```swift
try Item.filter(by: predicate, limit: 3, from: viewContext)
```

- Find managed object.

```swift
try Item.find(by: predicate, from: viewContext)
```

- Deleting an managed object.

```swift
try item.delete()
```

## LICENSE

```
MIT License

Copyright (c) 2022-2023 Kamaal Farah <kamaal111>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
