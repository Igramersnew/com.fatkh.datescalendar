import SwiftUI
import Combine
import EventKit
import Photos

struct Remind {
    let personId: UUID
    let remindDate: Date
}

final class ViewModel: ObservableObject {
    static let shared: ViewModel = .init()

    @Published private(set) var persons: [Person] { didSet {
        UserDefaults.standard.set(try? JSONEncoder().encode(persons), forKey: "persons")
        handleUpdate()
    } }

    @Published var currentTabBar = TabType.home
    @Published private(set) var isHiddenTabBar = false
    @Published private(set) var onEditing: Person?

    @Published private(set) var selectedLiked: Bool = true
    @Published private(set) var favorites: [Person] = []

    @Published var isPhotoAccessGranted: Bool { didSet { UserDefaults.standard.set(isPhotoAccessGranted, forKey: "isPhotoAccessGranted") } }
    @Published var isEventAccessGranted: Bool { didSet { UserDefaults.standard.set(isEventAccessGranted, forKey: "isEventAccessGranted") } }

    private var cancellables: Set<AnyCancellable> = []

    private init() {
        persons = (UserDefaults.standard.value(forKey: "persons") as? Data).flatMap { try? JSONDecoder().decode([Person].self, from: $0) } ?? MockStorage.persons
        isPhotoAccessGranted = UserDefaults.standard.bool(forKey: "isPhotoAccessGranted")
        isEventAccessGranted = UserDefaults.standard.bool(forKey: "isEventAccessGranted")
        handleUpdate()

        $currentTabBar.sink { tab in
            if let person = self.onEditing, tab != .create {
                self.update(update: .delete(person))
                self.update(update: .add(person))
                self.onEditing = nil
            }
        }.store(in: &cancellables)
    }

    func update(update: Update) {
        switch update {
        case .add(let person):
            persons.append(person)
        case .delete(let person):
            if let index = persons.firstIndex(where: { $0.id == person.id }) {
                persons.remove(at: index)
            }
        case .edit(let person):
            if let index = persons.firstIndex(where: { $0.id == person.id }) {
                onEditing = persons[index]
                currentTabBar = .create
            }
        case .like(let person):
            if let index = persons.firstIndex(where: { $0.id == person.id }) {
                persons[index].isLiked = true
                handleUpdate()
            }
        case .dislike(let person):
            if let index = persons.firstIndex(where: { $0.id == person.id }) {
                persons[index].isLiked = false
                handleUpdate()
            }
        case .setTabBar(let hidden):
            isHiddenTabBar = hidden
        case .addReminder(let person):
            if let index = persons.firstIndex(where: { $0.id == person.id }) {
                self.update(update: .requestEventAccess)

                guard isEventAccessGranted else { return }

                persons[index].isRemind = true
                addReminder(person: person)
                handleUpdate()
            }
        case .removeReminder(let person):
            if let index = persons.firstIndex(where: { $0.id == person.id }) {
                self.update(update: .requestEventAccess)

                guard isEventAccessGranted else { return }

                persons[index].isRemind = false
                removeReminder(person: person)
                handleUpdate()
        }
        case .requestEventAccess:
            requestEventAccess()
        case .requestPhotoAccess:
            requestPhotoAccess()
        }
    }

    private func requestEventAccess() {
        guard EKEventStore.authorizationStatus(for: .reminder) == .notDetermined else { return }

        EKEventStore().requestAccess(to: .reminder) { [weak self] granted, _ in
            DispatchQueue.main.async {
                self?.isEventAccessGranted = granted
            }
        }
    }

    private func requestPhotoAccess() {
        guard PHPhotoLibrary.authorizationStatus(for: .readWrite) == .notDetermined else { return }
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            DispatchQueue.main.async {
                switch status {
                case .denied:
                    self?.isPhotoAccessGranted = false
                case .restricted:
                    self?.isPhotoAccessGranted = false
                case .notDetermined:
                    self?.isPhotoAccessGranted = false
                case .authorized:
                    self?.isPhotoAccessGranted = true
                case .limited:
                    self?.isPhotoAccessGranted = true
                @unknown default:
                    self?.isPhotoAccessGranted = false
                }
            }
        }
    }

    private func removeReminder(person: Person) {
        let store = EKEventStore()
        guard isEventAccessGranted, let calendar = store.defaultCalendarForNewReminders() else { return }

        store.fetchReminders(matching: store.predicateForReminders(in: [calendar])) { reminders in
            reminders?.first { $0.title == person.name }.map {
                try? store.remove($0, commit: true)
            }
        }
    }


    private func addReminder(person: Person) {
        guard isEventAccessGranted else { return }

        let store = EKEventStore()

        let reminder = EKReminder(eventStore: store)
        reminder.title = person.name
        reminder.startDateComponents = Calendar.current.dateComponents([.day, .month, .year], from: person.meetingDate)
        reminder.notes = person.notes
        reminder.calendar = store.defaultCalendarForNewReminders()

        try? store.save(reminder, commit: true)
    }

    private func handleUpdate() {
        favorites = persons.filter { $0.isLiked == selectedLiked }
    }
}
