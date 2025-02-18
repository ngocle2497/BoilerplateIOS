import Foundation
import Combine

extension Publisher {
    /// Publishes either the most-recent or first element published by the upstream publisher in the specified time interval. It running on Main thread
    func throttle(for interval: DispatchQueue.SchedulerTimeType.Stride, latest: Bool) -> Publishers.Throttle<Self, DispatchQueue> {
        return self.throttle(for: interval, scheduler: DispatchQueue.main, latest: latest)
    }
    
    /// Publishes elements only after a specified time interval elapses between events. It running on Main thread
    func debounce(for interval: DispatchQueue.SchedulerTimeType.Stride) -> Publishers.Debounce<Self, DispatchQueue> {
        return self.debounce(for: interval, scheduler: DispatchQueue.main)
    }
    
    func sink<Object: AnyObject>(with object: Object, receiveValue: @escaping ((Object, Self.Output) -> Void)) -> AnyCancellable {
        return self.sink(receiveCompletion: {_ in }) { [weak object] output in
            guard let object else {
                return
            }
            receiveValue(object, output)
        }
    }
    
    func sink<Object: AnyObject>(with object: Object, receiveCompletion: @escaping ((Object, Subscribers.Completion<Self.Failure>) -> Void), receiveValue: @escaping ((Object, Self.Output) -> Void)) -> AnyCancellable {
        return self.sink(receiveCompletion: { [weak object] comp in
            guard let object else {
                return
            }
            receiveCompletion(object, comp)
        }) { [weak object] output in
            guard let object else {
                return
            }
            receiveValue(object, output)
        }
    }
}
