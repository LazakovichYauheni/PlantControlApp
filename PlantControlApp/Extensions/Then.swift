import Foundation

/// Протокол для конфигурации объекта после его создания
public protocol Then {}

extension Then where Self: NSObject {
    @inlinable
    public func then(_ block: (Self) -> Void) -> Self {
        block(self)
        return self
    }
}

/// Подпись NSObject'а под протокол Then
extension NSObject: Then {}
