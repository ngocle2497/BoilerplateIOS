import Foundation
import Adapter
import Alamofire

public final class EventSource<T: Codable>: Cancellation {
    private var request: DataStreamRequest!
    private var url: URLRequestConvertible
    
    private var retryAttempts = 0
    private var maxRetryAttempts = 5
    private weak var session: Session?
    private var messageType: T.Type
    
    internal struct EventSourceHandler {
        var onMessage: ((T) -> Void)?
        var onCompletion: (() -> Void)?
    }
    
    private var internalHandler = EventSourceHandler()
    
    public init(url: URLRequestConvertible, type: T.Type, session: Session = Session.default, onMessage: ((T) -> Void)? = nil, onCompletion: (() -> Void)? = nil) {
        self.url = url
        self.messageType = type
        self.session = session
        internalHandler.onMessage = onMessage
        internalHandler.onCompletion = onCompletion
    }
    
    private func reconnect() {
        retryAttempts += 1
        start()
    }
    
    private func setupRequest() {
        request = session?.eventSourceRequest(url)
    }
    
    public func start() {
        cancel()
        setupRequest()
        request.responseEventSource {[weak self] event in
            guard let strongSelf = self else {
                return
            }
            
            switch event.event {
            case .message(let message):
                strongSelf.retryAttempts = 0
                if let onMessage = strongSelf.internalHandler.onMessage {
                    do {
                        let json = try JSONDecoder().decode(strongSelf.messageType, from: message.data!.data(using: .utf8)!)
                        onMessage(json)
                    } catch {}
                }
                break
            case .complete(let complete):
                if complete.error?.isExplicitlyCancelledError == true || ((complete.error?.localizedDescription.contains("cancel")) != nil) ||
                    strongSelf.retryAttempts < strongSelf.maxRetryAttempts {
                    if let onCompletion = strongSelf.internalHandler.onCompletion {
                        onCompletion()
                    }
                    break
                }
                strongSelf.reconnect()
                break
            }
        }
    }
    
    public func cancel() {
        if request != nil {
            request.cancel()
            request = nil
        }
    }
    
    deinit {
        self.cancel()
    }
}

extension Session {
    public func eventSourceRequest(_ convertible: URLRequestConvertible, lastEventID: String? = nil) -> DataStreamRequest {
        do {
            var urlRequest = try convertible.asURLRequest()
            urlRequest.timeoutInterval = TimeInterval(Int32.max)
            urlRequest.headers.add(name: "Accept", value: "text/event-stream")
            urlRequest.headers.add(name: "Cache-Control", value: "no-cache")
            if let lastEventID = lastEventID {
                urlRequest.headers.add(name: "Last-Event-ID", value: lastEventID)
            }
            return streamRequest(urlRequest)
        } catch {
            return  streamRequest(convertible)
        }
    }
}

extension DataStreamRequest {
    
    public struct EventSource {
        
        let event: EventSourceEvent
        
        let token: CancellationToken
        
        func cancel() {
            token.cancel()
        }
    }
    
    enum EventSourceEvent {
        case message(EventSourceMessage)
        case complete(Completion)
    }
    
    @discardableResult func responseEventSource(using serializer: EventSourceSerializer = EventSourceSerializer(), on queue: DispatchQueue = .main, handler: @escaping (EventSource) -> Void) -> DataStreamRequest {
        return responseStream(using: serializer, on: queue) { stream in
            switch stream.event {
            case .stream(let result):
                for message in try result.get() {
                    handler(EventSource(event: .message(message), token: stream.token))
                }
            case .complete(let completion):
                handler(EventSource(event: .complete(completion), token: stream.token))
            }
        }
    }
    
}

final class EventSourceSerializer: DataStreamSerializer {
    
    static let doubleNewlineDelimiter = "\n\n".data(using: .utf8)!
    
    let delimiter: Data
    
    var buffer = Data()
    
    init(delimiter: Data = doubleNewlineDelimiter) {
        self.delimiter = delimiter
    }
    
    func serialize(_ data: Data) throws -> [EventSourceMessage] {
        buffer.append(data)
        return extractMessagesFromBuffer().compactMap(EventSourceMessage.init(parsing:))
    }
    
    private func extractMessagesFromBuffer() -> [String] {
        var messages = [String]()
        var searchRange: Range<Data.Index> = buffer.startIndex..<buffer.endIndex
        
        while let delimiterRange = buffer.range(of: delimiter, in: searchRange) {
            let subdata = buffer.subdata(in: searchRange.startIndex..<delimiterRange.endIndex)
            
            if let message = String(bytes: subdata, encoding: .utf8) {
                messages.append(message)
            }
            
            searchRange = delimiterRange.endIndex..<buffer.endIndex
        }
        
        buffer.removeSubrange(buffer.startIndex..<searchRange.startIndex)
        
        return messages
    }
    
}


struct EventSourceMessage {
    
    public var event: String?
    public var id: String?
    public var data: String?
    public var retry: String?
    
}

extension EventSourceMessage {
    
    internal init?(parsing string: String) {
        let fields = string.components(separatedBy: "\n").compactMap(Field.init(parsing:))
        for field in fields {
            switch field.key {
            case .event:
                self.event = self.event.map { $0 + "\n" + field.value } ?? field.value
            case .id:
                self.id = self.id.map { $0 + "\n" + field.value } ?? field.value
            case .data:
                self.data = self.data.map { $0 + "\n" + field.value } ?? field.value
            case .retry:
                self.retry = self.retry.map { $0 + "\n" + field.value } ?? field.value
            }
        }
    }
    
}

extension EventSourceMessage {
    
    internal struct Field {
        
        internal enum Key: String {
            case event
            case id
            case data
            case retry
        }
        
        internal var key: Key
        internal var value: String
        
        internal init?(parsing string: String) {
            let scanner = Scanner(string: string)
            
            guard let key = scanner.scanUpToString(":").flatMap(Key.init(rawValue:)) else {
                return nil
            }
            
            _ = scanner.scanString(":")
            
            guard let value = scanner.scanUpToString("\n") else {
                return nil
            }
            
            self.key = key
            self.value = value
        }
    }
}
