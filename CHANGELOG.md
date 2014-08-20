CHANGELOG
====

Timetables 1.1
---

* User-side:
	* Fix typo 'Пракитика' (#1)
	* Fix bug with Sunday case showing (#4)
	* Fix bug with scrolling days with numerous lessons on 3.5" iPhone
	* Stability improvements
	* Add alert for special handling for `response.statusCode == 0` (when network is down)
	* Add Pull-To-Refresh gesture on main view
	* Add iOS 7.0.x support (#2)
	* Add background for activity type label and swapped it with location label 
	* Resizable cells in Main View
	* _Properly_ resizable cells in Saved Groups
	* When exiting and re-entering app your group is shown instead of last opened group (actually, a bug, which was fixed)
	* _Totally new_ SubjectDetailView: now shows as a alert, instead of view
	* Implement caching (#3)
* Code:
	* Converted `TTPParser`, `TTPTimetableAccessor` to singletons, now initialized via `[TTPSomething sharedSomething]`
	* Reduced memory usage to 6 MB average
	* Created `TTPSharedSettingsController` - class, which controlls access to `NSUserDefaults` and atomically works on setings and all the properties available
	* Big refactoring
	* Code style improvements, documentation improvements
	


Timetables 1.0
---

* Initial release