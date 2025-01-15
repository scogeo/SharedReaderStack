import Sharing

extension SharedReaderKey {
  static func counter(_ name: String) -> Self where Self == CounterKey.Default {
    Self[CounterKey(name: name), default: 0]
  }
}

struct CounterKey: SharedReaderKey {
  let name: String
  
  var id: some Hashable { name }
  
  func load(context: Sharing.LoadContext<Int>, continuation: Sharing.LoadContinuation<Int>) {
    // Return initial value, load() not supported.
    continuation.resumeReturningInitialValue()
  }
  
  func subscribe(context: Sharing.LoadContext<Int>, subscriber: Sharing.SharedSubscriber<Int>) -> Sharing.SharedSubscription {
    let task = Task {
      defer {
        print("Counter \(name): canceled")
      }
      var value = 0
      while !Task.isCancelled {
        print("Counter \(name): yielding \(value)")
        subscriber.yield(value)
        value += 1
        try await Task.sleep(for: .seconds(1))
      }
    }
    
    return SharedSubscription {
      print("Counter \(name): cancel requested")
      task.cancel()
    }
  }

}
