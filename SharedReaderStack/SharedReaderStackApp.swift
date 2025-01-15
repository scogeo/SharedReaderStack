import ComposableArchitecture
import SwiftUI

@main
struct SharedReaderStackApp: App {
  let store = Store(initialState: AppFeature.State()) {
    AppFeature()
      ._printChanges()
  }
  
  var body: some Scene {
    WindowGroup {
      AppView(store: store)
    }
  }
}
