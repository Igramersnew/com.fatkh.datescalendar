import Foundation

enum Update {
    case add(Person)
    case delete(Person)
    case edit(Person)
    case like(Person)
    case dislike(Person)
    case setTabBar(hidden: Bool)
    case addReminder(Person)
    case removeReminder(Person)

    case requestPhotoAccess
    case requestEventAccess
}
