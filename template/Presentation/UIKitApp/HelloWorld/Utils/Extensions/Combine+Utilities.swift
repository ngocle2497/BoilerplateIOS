import Foundation
import Combine
import UIKit

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

protocol UIControlPublishable: UIControl {}
extension UIControlPublishable {
    func publisher(for event: UIControl.Event) -> UIControl.InteractionPublisher<Self> {
        return InteractionPublisher(control: self, event: event)
    }
}
extension UIControl: UIControlPublishable {
    class InteractionSubscription<S: Subscriber, C: UIControl>: Subscription where S.Input == C {
        private let subscriber: S?
        private weak var control: C?
        private let event: UIControl.Event
        init(subscriber: S,
             control: C?,
             event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            self.event = event
            self.control?.addTarget(self, action: #selector(handleEvent), for: event)
        }
        @objc func handleEvent(_ sender: UIControl) {
            guard let control = self.control else {
                return
            }
            _ = self.subscriber?.receive(control)
        }
        func request(_ demand: Subscribers.Demand) {}
        func cancel() {
            self.control?.removeTarget(self, action: #selector(handleEvent), for: self.event)
            self.control = nil
        }
    }
    enum InteractionPublisherError: Error {
        case objectFoundNil
    }
    struct InteractionPublisher<C: UIControl>: Publisher {
        typealias Output = C
        typealias Failure = InteractionPublisherError
        private weak var control: C?
        private let event: UIControl.Event
        init(control: C, event: UIControl.Event) {
            self.control = control
            self.event = event
        }
        func receive<S>(subscriber: S) where S : Subscriber, InteractionPublisherError == S.Failure, C == S.Input {
            guard let control = control else {
                subscriber.receive(completion: .failure(.objectFoundNil))
                return
            }
            let subscription = InteractionSubscription(
                subscriber: subscriber,
                control: control,
                event: event
            )
            subscriber.receive(subscription: subscription)
        }
    }
}
