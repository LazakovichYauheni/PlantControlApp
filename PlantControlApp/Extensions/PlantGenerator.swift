import Foundation

final class PlantGenerator {
    static func generatePlant(name: String) -> PlantModel {
        .init(
            name: name,
            dailyWaterRate: Int.random(in: 5..<120),
            dailyLightRate: Int.random(in: 5..<120),
            humidity: Float.random(in: 10..<100),
            waterLevel: Float.random(in: 10..<100),
            lightning: Float.random(in: 10..<100)
        )
    }
}
