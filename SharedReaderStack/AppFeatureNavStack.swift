import ComposableArchitecture
import IdentifiedCollections
import SwiftUI


// Note: This was designed to show @SharedReader retention in NavStack, but sheet also reproduces.
@Reducer
struct AppFeatureNavStack {
  @Reducer(state: .equatable)
  enum Path {
    case child(ChildFeature)
  }
  
  struct ChildRow: Equatable, Identifiable {
    var id: String
  }
  
  @ObservableState
  struct State: Equatable {
    var path = StackState<Path.State>()
    var children = [
      ChildRow(id: "Child 1"),
      ChildRow(id: "Child 2"),
      ChildRow(id: "Child 3")
    ]
    @Presents var childSheet: ChildFeature.State?
  }
  
  enum Action {
    case childClicked(String)
    case path(StackActionOf<Path>)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .childClicked(id):
        state.path.append(.child(.init(name: id)))
        return .none
        
      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

struct AppNavStackView: View {
  @Bindable var store: StoreOf<AppFeatureNavStack>
  
  var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      List {
        ForEach(store.children) { child in
          Button(child.id, action: { store.send(.childClicked(child.id)) })
        }
      }
    } destination: { store in
      switch store.case {
      case let .child(store):
        ChildView(store: store)
      }
    }
  }
  
}
