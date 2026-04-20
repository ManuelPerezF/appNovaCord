//
//  OperadoresViewModelswift
//  AppNovaAMSCoord
//
//  Created by Manuel Antonio Perez Fonseca on 28/11/25.
//



import Foundation

public enum WebSocketConnectionError: Error {
    case encodingError
    case decodingError
    case connectionError
    case disconnected
    case closed
    case transportError
}

public final class WebSocketConnection<Incoming: Decodable & Sendable,
                                       Outgoing: Encodable & Sendable>: NSObject, @unchecked Sendable {
    
    private let webSocketTask: URLSessionWebSocketTask
    
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    
    public init(
        webSocketTask: URLSessionWebSocketTask,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.webSocketTask = webSocketTask
        self.encoder = encoder
        self.decoder = decoder
        super.init()
        webSocketTask.resume()
    }
    
    deinit {
        webSocketTask.cancel(with: .goingAway, reason: nil)
    }
    
    private func receiveSingleMessage() async throws -> Incoming {
        let result = try await webSocketTask.receive()
        
        switch result {
        case .data(let data):
            guard let msg = try? decoder.decode(Incoming.self, from: data) else {
                throw WebSocketConnectionError.decodingError
            }
            return msg
            
        case .string(let text):
            guard
                let data = text.data(using: .utf8),
                let msg = try? decoder.decode(Incoming.self, from: data)
            else {
                throw WebSocketConnectionError.decodingError
            }
            return msg
            
        @unknown default:
            webSocketTask.cancel(with: .unsupportedData, reason: nil)
            throw WebSocketConnectionError.decodingError
        }
    }
    
    public func send(_ message: Outgoing) async throws {
        guard let data = try? encoder.encode(message) else {
            throw WebSocketConnectionError.encodingError
        }
        
        do {
            try await webSocketTask.send(.data(data))
        } catch {
            switch webSocketTask.closeCode {
            case .invalid:
                throw WebSocketConnectionError.connectionError
            case .goingAway:
                throw WebSocketConnectionError.disconnected
            case .normalClosure:
                throw WebSocketConnectionError.closed
            default:
                throw WebSocketConnectionError.transportError
            }
        }
    }
    
    public func receiveOnce() async throws -> Incoming {
        do {
            return try await receiveSingleMessage()
        } catch let err as WebSocketConnectionError {
            throw err
        } catch {
            switch webSocketTask.closeCode {
            case .invalid:
                throw WebSocketConnectionError.connectionError
            case .goingAway:
                throw WebSocketConnectionError.disconnected
            case .normalClosure:
                throw WebSocketConnectionError.closed
            default:
                throw WebSocketConnectionError.transportError
            }
        }
    }
    
    public func receive() -> AsyncThrowingStream<Incoming, Error> {
        AsyncThrowingStream { [weak self] in
            guard let self else { return nil }
            let message = try await self.receiveOnce()
            return Task.isCancelled ? nil : message
        }
    }
    
    public func close() {
        webSocketTask.cancel(with: .normalClosure, reason: nil)
    }
}
