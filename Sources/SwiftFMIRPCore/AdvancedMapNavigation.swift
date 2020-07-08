

import Foundation

let MAP_SIZE = 7

struct AdvancedMapGenerator : MapGenerator {
    func generate(players: [Player]) -> Map {
        return AdvancedMap(players: players)
    }
}
class AdvancedMapTile: MapTile {
    var type: MapTileType
    var state: String
    
    init(type: MapTileType) {
        self.type = type
        self.state = ""
    }
}

class AdvancedMap : Map {
    required init(players: [Player]) {
        self.players = players
        
        playerCoordinates = [String : (Int, Int)]()
        playerCoordinates[players[0].name] = (0, 0)
        playerCoordinates[players[1].name] = (6, 0)
        if (players.count >= 3) {
            playerCoordinates[players[2].name] = (0, 6)
        }
        if (players.count >= 4) {
            playerCoordinates[players[3].name] = (6, 6)
        }
        
    }
    
    var players: [Player]
    var maze: [[MapTile]] = [
        [AdvancedMapTile(type: MapTileType.player), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.player)],
        
        [AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty)],
        
        [AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty)],
        
        [AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty)],
        
        [AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty)],
        
        [AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty)],
        
        [AdvancedMapTile(type: MapTileType.player), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.player)]
        
    ]
    
    var playerCoordinates: [String : (Int, Int)]
    
    func availableMoves(player: Player) -> [PlayerMove] {
        if (player.hero.energy <= 0) {
            return []
        }
        var moves = [StandartPlayerMove]()
        let pY = playerCoordinates[player.name]!.0
        let pX = playerCoordinates[player.name]!.1
        
        if (pX + 1 < MAP_SIZE && maze[pY][pX + 1].type == MapTileType.empty) {
            moves.append(StandartPlayerMove.init(direction: MapMoveDirection.right))
        }
        
        if (pX - 1 >= 0 && maze[pY][pX - 1].type == MapTileType.empty) {
            moves.append(StandartPlayerMove.init(direction: MapMoveDirection.left))
        }
        
        if (pY + 1 < MAP_SIZE && maze[pY + 1][pX].type == MapTileType.empty) {
            moves.append(StandartPlayerMove.init(direction: MapMoveDirection.down))
        }
        
        if (pY - 1 >= 0 && maze[pY - 1][pX].type == MapTileType.empty) {
            moves.append(StandartPlayerMove.init(direction: MapMoveDirection.up))
        }
        
        return moves
    }
    
    func move(player: inout Player, move: PlayerMove) {
        
        
        if player.hero.energy > 0 {
            player.hero.energy -= 1
        }
        
        var newY = playerCoordinates[player.name]!.0
        var newX = playerCoordinates[player.name]!.1
        
        switch move.direction {
        case MapMoveDirection.up:
            newY -= 1
        case MapMoveDirection.down:
            newY += 1
        case MapMoveDirection.left:
            newX -= 1
        case MapMoveDirection.right:
            newX += 1
        }
        
        maze[playerCoordinates[player.name]!.0][playerCoordinates[player.name]!.1].type = MapTileType.empty
        maze[newY][newX].type = MapTileType.player
        playerCoordinates[player.name] = (newY, newX)
        
        print("x = \(playerCoordinates[player.name]!.0) y = \(playerCoordinates[player.name]!.1)")
        print("energy left = \(player.hero.energy)")
        
        //ТОДО: редуцирай енергията на героя на играча с 1
    }
    
}
