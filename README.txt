FindMyCar — Lab 8
Platform: Swift / SwiftUI

OPEN AND RUN
1. Open FindMyCar.xcodeproj in Xcode 16 or later (iOS 17+).
2. Select the FindMyCar scheme and an iPhone simulator, then Run.
3. Set a simulated location under Features > Location > Custom Location.
   The handout's CMU coordinates are 40.444644, -79.945424.
4. Tap Here's My Car and allow location access. Confirm the saved coordinates.
5. Tap Where's My Car? to see the parked car and your current position on the map.
6. Close and relaunch the app: the saved location is restored from Coordinates.plist.

PROJECT CONTENTS
FindMyCar/Models: CarCoordinate, CarLocation, LocationManager.
FindMyCar/Views: AppView and MapView.
Tests: the seven required model tests plus restoration and corrupt-data checks.
UITests: repeatable screenshot checks for the parking flow and denied permission.
Screenshots: actual simulator captures; coordinates are simulated, not a real trip.

TESTING
Use the FindMyCar scheme and Product > Test for model tests.
The FindMyCarScreenshots scheme also includes UI checks. Set a simulator location
before running the parking-flow test. The UI tests reset this app's simulator
location permission to exercise the permission dialog.

IMPLEMENTATION NOTES
Uses @Observable, NavigationStack, MapKit, CLLocationManagerDelegate, and an XML
plist as specified. Every function has a purpose comment. Saves are atomic.
A failed save shows Location Error, not Location Saved. GPS updates only run during
a save request, so reopening the app cannot replace the parked car's location.
Tests use unique temporary plists and do not change the user's saved parking spot.
The lab's (0, 0) sentinel is retained to represent no stored car location.
Map tiles require an internet connection. Running on a physical device also
requires choosing your signing team in Xcode.

CANVAS / GITHUB REQUIREMENTS
The assignment additionally requires a repository link:
  repository: hw_lab_<your_andrewid>
  branch: hw_lab8_Findmycar
Commit and push these source files to that branch and share the repository with
your assigned CA. Include the repository/branch link with the Swift screenshots.
Repository: https://github.com/akkubais/hw_lab_akkubais
Lab branch: hw_lab8_Findmycar
Canvas submission must still be completed separately.

VERIFIED OUTPUTS
All 11 tests passed with zero failures on 31 October 2026 (see TestResults.txt).
01-home.png: initial screen with map navigation disabled.
02-location-saved.png: successful save at the handout's CMU coordinates.
03-saved-home.png: saved state with map navigation enabled.
04-car-map.png: red parked-car marker and blue current-user marker; the simulated
user moved to 40.446000, -79.943500 while the parked car stayed at its saved point.
05-restored-after-relaunch.png: saved state restored after terminating/relaunching.
06-location-error.png: feedback after denying location permission.
All six PNGs were exported directly from the successful XCTest screen tests.
