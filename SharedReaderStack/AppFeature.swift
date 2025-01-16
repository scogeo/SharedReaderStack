import ComposableArchitecture
import IdentifiedCollections
import SwiftUI

@Reducer
struct AppFeature {
  @Reducer(state: .equatable)
  enum Path {
    case child(ChildFeature)
  }
  
  struct ChildRow: Equatable, Identifiable {
    var id: String
  }
  
  @ObservableState
  struct State: Equatable {
    @Presents var childSheet: ChildFeature.State?
    var child: ChildFeature.State?
    var isChildPresent: Bool { child != nil }
  }
  
  enum Action {
    case child(ChildFeature.Action)
    case isChildPresent(Bool)
    case childClicked
    case childSheetClicked
    case childSheet(PresentationAction<ChildFeature.Action>)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {

      case .childClicked:
        state.child = .init(name: "Child Sheet (TCA Optional Child)")
        return .none
        
      case .childSheetClicked:
        state.childSheet = .init(name: "Child Sheet (TCA Presentation)")
        return .none
        
      case .isChildPresent(_):
        state.child = nil
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.$childSheet, action: \.childSheet) {
      ChildFeature()
    }
    .ifLet(\.child, action: \.child) {
      ChildFeature()
    }
  }
}

struct AppView: View {
  @Bindable var store: StoreOf<AppFeature>
  @State var isShowingSheet = false
  @State var isShowingIsolatedStoreSheet = false
  
  var body: some View {
    VStack {
      Button("Child Sheet (TCA Presentation)", action: { store.send(.childSheetClicked) } )
        .padding()
        .sheet(item: $store.scope(state: \.childSheet, action: \.childSheet)) { store in
          ChildView(store: store)
        }
      
      Button("Child Sheet (TCA Optional Child)", action: { store.send(.childClicked) } )
        .padding()
        .sheet(isPresented: $store.isChildPresent.sending(\.isChildPresent)) {
          if let store = store.scope(state: \.child, action: \.child) {
            ChildView(store: store)
          }
        }
      
      Button("Child Sheet (TCA isolated store)", action: { isShowingSheet.toggle()})
        .padding()
        .sheet(isPresented: $isShowingIsolatedStoreSheet) {
          let store = Store(initialState: .init(name: "Child Sheet (TCA isolated store)")) {
            ChildFeature()
          }
          ChildView(store: store)
        }
      
      Button("Child Sheet (SwiftUI)", action: { isShowingSheet.toggle()})
        .padding()
        .sheet(isPresented: $isShowingSheet) {
          ChildModelView(model: .init(name: "Child Sheet (SwiftUI)"))
        }
    }
    
  }
  
}
