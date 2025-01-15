import SwiftUI
import Sharing

@Observable
class ChildModel {
  
  @ObservationIgnored
  @SharedReader var counter: Int
  let name: String
  
  init(name: String) {
    self.name = name
    self._counter = SharedReader(.counter(name))
  }
}

struct ChildModelView: View {
  let model: ChildModel
  
  public var body: some View {
    VStack {
      Text(model.name)
      Text("\(model.counter)")
    }
  }
}
