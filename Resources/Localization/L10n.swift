//
//  L10n.swift
//  Tracker
//
//  Created by Svetlana on 2026/3/23.
//
import Foundation

enum L10n {

    // MARK: - Category Picker
    enum CategoryPicker {
        static var stateText: String { NSLocalizedString("category_picker_state_text", comment: "") }
        static var addButton: String { NSLocalizedString("category_picker_add_button", comment: "") }
        static var title: String { NSLocalizedString("category_picker_title", comment: "") }
        static var deleteTitle: String { NSLocalizedString("category_delete_title", comment: "") }
        static var deleteMessage: String { NSLocalizedString("category_delete_message", comment: "") }
    }

    // MARK: - Edit
    enum EditCategory {
        static var title: String { NSLocalizedString("edit_category_title", comment: "") }
    }

    // MARK: - Filter
    enum Filter {
        static var title: String { NSLocalizedString("filter_title", comment: "") }
        static var button: String { NSLocalizedString("filter_button", comment: "") }
    }

    // MARK: - Tracker Filter
    enum TrackerFilter {
        static var all: String { NSLocalizedString("filter_all", comment: "") }
        static var today: String { NSLocalizedString("filter_today", comment: "") }
        static var completed: String { NSLocalizedString("filter_completed", comment: "") }
        static var uncompleted: String { NSLocalizedString("filter_uncompleted", comment: "") }
    }

    // MARK: - New Category
    enum NewCategory {
        static var title: String { NSLocalizedString("new_category_title", comment: "") }
        static var placeholder: String { NSLocalizedString("new_category_placeholder", comment: "") }
    }

    // MARK: - Weekday
    enum Weekday {
        static var monday: String { NSLocalizedString("weekday_monday", comment: "") }
        static var tuesday: String { NSLocalizedString("weekday_tuesday", comment: "") }
        static var wednesday: String { NSLocalizedString("weekday_wednesday", comment: "") }
        static var thursday: String { NSLocalizedString("weekday_thursday", comment: "") }
        static var friday: String { NSLocalizedString("weekday_friday", comment: "") }
        static var saturday: String { NSLocalizedString("weekday_saturday", comment: "") }
        static var sunday: String { NSLocalizedString("weekday_sunday", comment: "") }

        static var shortMonday: String { NSLocalizedString("weekday_short_monday", comment: "") }
        static var shortTuesday: String { NSLocalizedString("weekday_short_tuesday", comment: "") }
        static var shortWednesday: String { NSLocalizedString("weekday_short_wednesday", comment: "") }
        static var shortThursday: String { NSLocalizedString("weekday_short_thursday", comment: "") }
        static var shortFriday: String { NSLocalizedString("weekday_short_friday", comment: "") }
        static var shortSaturday: String { NSLocalizedString("weekday_short_saturday", comment: "") }
        static var shortSunday: String { NSLocalizedString("weekday_short_sunday", comment: "") }
    }

    // MARK: - New Tracker
    enum NewTracker {
        static var title: String { NSLocalizedString("new_tracker_title", comment: "") }
        static var placeholder: String { NSLocalizedString("new_tracker_placeholder", comment: "") }
    }

    // MARK: - Tracker
    enum Tracker {
        static var newHabitTitle: String { NSLocalizedString("tracker_new_habit_title", comment: "") }
        static var newEventTitle: String { NSLocalizedString("tracker_new_event_title", comment: "") }
        static var editHabitTitle: String { NSLocalizedString("tracker_edit_habit_title", comment: "") }
        static var editEventTitle: String { NSLocalizedString("tracker_edit_event_title", comment: "") }
        static var scheduleEveryDay: String { NSLocalizedString("schedule_every_day", comment: "") }

        static var typeHabit: String { NSLocalizedString("tracker_type_habit", comment: "") }
        static var typeEvent: String { NSLocalizedString("tracker_type_event", comment: "") }
        static var creationTitle: String { NSLocalizedString("tracker_creation_title", comment: "") }
        static var deleteTitle: String { NSLocalizedString("tracker_delete_title", comment: "") }
        static var deleteMessage: String { NSLocalizedString("tracker_delete_message", comment: "") }
        static var daysCount: String { NSLocalizedString("days_count", comment: "")}
    }

    // MARK: - Trackers
    enum Trackers {
        static var searchPlaceholder: String { NSLocalizedString("search_placeholder", comment: "") }
        static var stateViewTitle: String { NSLocalizedString("trackers_state_view_title", comment: "") }
        static var stateViewEmptyFilter: String { NSLocalizedString("trackers_state_view_empty_filter", comment: "") }
        static var pinnedCategoryTitle: String { NSLocalizedString("pinned_category_title", comment: "") }
        static var pinButtonTitle: String { NSLocalizedString("pin_button_title", comment: "") }
        static var unpinButtonTitle: String { NSLocalizedString("unpin_button_title", comment: "") }
    }

    // MARK: - Statistics
    enum Statistics {
        static var stateViewTitle: String { NSLocalizedString("statistics_state_view_title", comment: "") }
        static var bestStreakCardTitle: String { NSLocalizedString("best_streak_card_title", comment: "") }
        static var perfectDaysCardTitle: String { NSLocalizedString("perfect_days_card_title", comment: "") }
        static var completedTrackersCardTitle: String { NSLocalizedString("completed_trackers_card_title", comment: "") }
        static var averageCardTitle: String { NSLocalizedString("average_card_title", comment: "") }
    }

    // MARK: - Tab Bar
    enum TabBar {
        static var statisticsTitle: String { NSLocalizedString("statistics_title", comment: "") }
        static var trackersTitle: String { NSLocalizedString("trackers_title", comment: "") }
    }

    // MARK: - Onboarding
    enum Onboarding {
        static var firstPageText: String { NSLocalizedString("onboarding_first_page_text", comment: "") }
        static var secondPageText: String { NSLocalizedString("onboarding_second_page_text", comment: "") }
        static var actionButtonTitle: String { NSLocalizedString("action_button_title", comment: "") }
    }

    // MARK: - Common
    enum Common {
        static var categoryTitle: String { NSLocalizedString("category_title", comment: "") }
        static var scheduleTitle: String { NSLocalizedString("schedule_title", comment: "") }
        static var emojiTitle: String { NSLocalizedString("emoji_title", comment: "") }
        static var colorTitle: String { NSLocalizedString("color_title", comment: "") }

        static var done: String { NSLocalizedString("done", comment: "") }
        static var cancel: String { NSLocalizedString("cancel", comment: "") }
        static var delete: String { NSLocalizedString("delete", comment: "") }
        static var edit: String { NSLocalizedString("edit", comment: "") }
        static var create: String { NSLocalizedString("create", comment: "") }
        static var save: String { NSLocalizedString("save", comment: "") }
    }
}
