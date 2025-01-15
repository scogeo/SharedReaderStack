import ComposableArchitecture
import SwiftUI

@Reducer
struct ChildFeature {
  
  @ObservableState
  struct State: Equatable, Identifiable {
    
    @SharedReader var counter: Int
    var id: String { name }
    let name: String
    
    init(name: String) {
      self.name = name
      self._counter = SharedReader(.counter(name))
    }
  }
}

struct ChildView: View {
  let store: StoreOf<ChildFeature>
  
  var body: some View {
    VStack {
      Text(store.name)
      Text("\(store.counter)")
    }
  }
}
