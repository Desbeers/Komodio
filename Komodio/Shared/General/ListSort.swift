//
//  ListSort.swift
//  Komodio (shared)
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyKodiAPI

/// Parts for sorting Kodi media lists
enum ListSort {
    // Just a Namespace
}

extension ListSort {

    /// Load the ``ListSort/Item`` settings
    /// - Returns: The ``ListSort/Item`` settings
    static func load() -> [ListSort.Item] {
        logger("Get ListSort Settings")
        if let settings = Cache.get(key: "ListSort", as: [ListSort.Item].self, root: true) {
            return settings
        }
        /// No settings found
        return []
    }

    /// Save the ``ListSort/Item`` settings to the cache
    /// - Parameter settings: All the current settings
    static func save(settings: [ListSort.Item]) {
        do {
            try Cache.set(key: "ListSort", object: settings, root: true)
        } catch {
            logger("Error saving ListSort settings")
        }
    }

    /// Struct for a `ListSort` item
    struct Item: Codable, Equatable {
        /// The ID of the item
        var id: String = ""
        /// The sort method
        var method: SortMethod = .title
        /// The sort order
        var order: SortOrder = .forward
    }

    /// The sort method of a list
    enum SortMethod: String, CaseIterable, Codable {
        /// Sort by title
        case title = "Sort by title"
        /// Sort by year
        case year = "Sort by year"
        /// Sort by duration
        case duration = "Sort by duration"
        /// Sort by date addedf
        case dateAdded = "Sort by date added"
    }

    /// The sort order of a list
    enum SortOrder: String, CaseIterable, Codable {
        /// Sort in forward ordeer
        case forward = "Forward"
        /// Sort in reverse order
        case reverse = "Reverse"
        /// The `SortOrder` value
        var value: SwiftUI.SortOrder {
            switch self {
            case .forward:
                return .forward
            case .reverse:
                return .reverse
            }
        }

        /// Label for the ``ListSort/SortOrder``
        /// - Parameter method: The ``ListSort/SortOrder
        /// - Returns: A String with the appropriate label
        func label(method: SortMethod) -> String {
            switch self {
            case .forward:
                switch method {
                case .title:
                    return "A - Z"
                case .duration:
                    return "Shortest first"
                case .dateAdded, .year:
                    return "Oldest first"
                }
            case .reverse:
                switch method {
                case .title:
                    return "Z - A"
                case .duration:
                    return "Longest first"
                case .dateAdded, .year:
                    return "Newest first"
                }
            }
        }
    }
}

extension Array where Element == any KodiItem {

    /// Sort an Array of any KodiItem's
    /// - Parameter sortItem: The sorting
    /// - Returns: A sorted Array
    func sorted(sortItem: ListSort.Item) -> Array {
        switch sortItem.method {
        case .title:
            return self.sorted(using: KeyPathComparator(\.title, order: sortItem.order.value))
        case .duration:
            return self.sorted(using: KeyPathComparator(\.duration, order: sortItem.order.value))
        case .dateAdded:
            return self.sorted(using: KeyPathComparator(\.dateAdded, order: sortItem.order.value))
        case .year:
            return self.sorted(using: [
                KeyPathComparator(\.year, order: sortItem.order.value),
                KeyPathComparator(\.title, order: .forward)
            ])
        }
    }
}

extension Array where Element: KodiItem {

    /// Sort an Array of KodiItem's of a specific type
    /// - Parameter sortItem: The sorting
    /// - Returns: A sorted Array
    func sorted(sortItem: ListSort.Item) -> Array {
        switch sortItem.method {
        case .title:
            return self.sorted(using: KeyPathComparator(\.title, order: sortItem.order.value))
        case .duration:
            return self.sorted(using: KeyPathComparator(\.duration, order: sortItem.order.value))
        case .dateAdded:
            return self.sorted(using: KeyPathComparator(\.dateAdded, order: sortItem.order.value))
        case .year:
            return self.sorted(using: [
                KeyPathComparator(\.year, order: sortItem.order.value),
                KeyPathComparator(\.title, order: .forward)
            ])
        }
    }
}
