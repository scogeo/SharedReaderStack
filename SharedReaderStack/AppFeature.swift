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
  }
  
  enum Action {
    case childSheetClicked
    case childSheet(PresentationAction<ChildFeature.Action>)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {

      case .childSheetClicked:
        state.childSheet = .init(name: "Child Sheet (TCA)")
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.$childSheet, action: \.childSheet) {
      ChildFeature()
    }
  }
}

struct AppView: View {
  @Bindable var store: StoreOf<AppFeature>
  @State var isShowingSheet = false
  
  var body: some View {
    VStack {
      Button("Child Sheet (TCA)", action: { store.send(.childSheetClicked) } )
        .padding()
        .sheet(item: $store.scope(state: \.childSheet, action: \.childSheet)) { store in
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
