import Foundation
import UIKit

/// Модель растения
public struct PlantModel {
    /// Id растения
    public let id: String = UUID().uuidString
    /// Название растения
    public let name: String
    /// Текущее суточное потребление воды
    public let dailyWaterRate: Int
    /// Текущее суточное потребление света
    public let dailyLightRate: Int
    /// Текущая влажность
    public let humidity: Float
    /// Текущий уровень жидкости в резервуаре
    public let waterLevel: Float
    /// Текущая освещенность
    public let lightning: Float
    /// Рандомный цвет для вью
    public let color: UIColor = {
        return UIColor(hue: CGFloat.random(in: 0...1), saturation: 0.59, brightness: 0.95, alpha: 1)
    }()
}
