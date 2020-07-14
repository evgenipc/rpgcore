
import Foundation


class AdvancedMapRenderer: MapRenderer {
    func render(map: Map) {
        for row in map.maze {
            self.renderMapRow(row: row)
        }
        
        renderMapLegend()
    }
    
    private func renderMapRow(row: [MapTile]) {
        var r = ""
        for tile in row {
            switch tile.type {
            case .chest:
                r += "📦"
            case .rock:
                r += "🗿"
            case .teleport:
                r += "💿"
            case .empty:
                r += "🛣"
            case .wall:
                r += "🧱"
            case .player:
                r += "🧙‍♂️"
            default:
                //empty
                r += " "
            }
        }
        
        print("\(r)")
    }
    
    private func renderMapLegend() {
        print("---MAP-LEGEND---")
        print("🛣 - road")
        print("🧙‍♂️ - player")
        print("💿 - teleport")
        print("📦 - chest")
        print("🗿 - rock")
        print("🧱 - wall")
        print("----------------")
    }
}
