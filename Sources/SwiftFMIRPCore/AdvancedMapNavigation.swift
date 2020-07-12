

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
        playerEnergy = [String : Int]()
        maze = AdvancedMap.generateMaze()
        
        setEnergyCounter(players)
        setPlayerStartCoordinates()
    }
    
    var players: [Player]
    var maze: [[MapTile]]
    var playerCoordinates: [String : (Int, Int)]
    var playerEnergy: [String : Int]
    
    func availableMoves(player: Player) -> [PlayerMove] {
        if (playerEnergy[player.name] ?? 0 <= 0) {
            return []
        }
        
        var moves = [StandartPlayerMove]()
        let pY = playerCoordinates[player.name]!.0
        let pX = playerCoordinates[player.name]!.1
        
        if (pX + 1 < MAP_SIZE && (maze[pY][pX + 1].type == MapTileType.empty || maze[pY][pX + 1].type == MapTileType.teleport)) {
            moves.append(StandartPlayerMove.init(direction: MapMoveDirection.right))
        }
        
        if (pX - 1 >= 0 && ( maze[pY][pX - 1].type == MapTileType.empty || maze[pY][pX - 1].type == MapTileType.teleport)) {
            moves.append(StandartPlayerMove.init(direction: MapMoveDirection.left))
        }
        
        if (pY + 1 < MAP_SIZE && (maze[pY + 1][pX].type == MapTileType.empty || maze[pY + 1][pX].type == MapTileType.teleport)) {
            moves.append(StandartPlayerMove.init(direction: MapMoveDirection.down))
        }
        
        if (pY - 1 >= 0 && (maze[pY - 1][pX].type == MapTileType.empty || maze[pY - 1][pX].type == MapTileType.teleport)) {
            moves.append(StandartPlayerMove.init(direction: MapMoveDirection.up))
        }
        
        return moves
    }
    
    func move(player: Player, move: PlayerMove) {
        if let currentPlayer = (players.first {
            (pl) -> Bool in
            pl.name == player.name
        }) {
            if playerEnergy[currentPlayer.name] ?? 0 > 0 {
                playerEnergy[currentPlayer.name]! -= 1
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
            
            if (maze[newY][newX].type == MapTileType.teleport) {
                let otherPortal: (Int, Int)? = maze.getSomePortalCoordinates(of: MapTileType.teleport, current: (newY, newX))
                
                if (otherPortal!.1 + 1 < MAP_SIZE && maze[otherPortal!.0][otherPortal!.1 + 1].type == MapTileType.empty) {
                    newX = otherPortal!.1 + 1
                    newY = otherPortal!.0
                } else if (otherPortal!.1 - 1 >= 0 &&  maze[otherPortal!.0][otherPortal!.1 - 1].type == MapTileType.empty) {
                    newX = otherPortal!.1 - 1
                    newY = otherPortal!.0
                } else if (otherPortal!.0 + 1 < MAP_SIZE && maze[otherPortal!.0 + 1][otherPortal!.1].type == MapTileType.empty) {
                    newX = otherPortal!.1
                    newY = otherPortal!.0 + 1
                } else if (otherPortal!.0 - 1 >= 0 && maze[otherPortal!.0 - 1][otherPortal!.1].type == MapTileType.empty) {
                    newX = otherPortal!.1
                    newY = otherPortal!.0 - 1
                }
                    
                print (" New portal \(otherPortal!.0), \(otherPortal!.1)")
            }
            
            maze[playerCoordinates[currentPlayer.name]!.0][playerCoordinates[currentPlayer.name]!.1].type = MapTileType.empty
            maze[newY][newX].type = MapTileType.player
            playerCoordinates[currentPlayer.name] = (newY, newX)
            
            print("x = \(playerCoordinates[currentPlayer.name]!.0) y = \(playerCoordinates[currentPlayer.name]!.1)")
            print("energy left = \(playerEnergy[currentPlayer.name] ?? 0)")
            
        } else {
            print("Ooops...Something went wrong.")
            exit(0)
        }
    }
    
    func endPlayerTurn(player: Player) {
        playerEnergy[player.name] = player.hero.energy
    }
    
    private func setPlayerStartCoordinates() {
        playerCoordinates[players[0].name] = (0, 0)
        maze[0][0] = AdvancedMapTile(type: MapTileType.player)
        
        playerCoordinates[players[1].name] = (6, 6)
        maze[6][6] = AdvancedMapTile(type: MapTileType.player)
        
        if (players.count >= 3) {
            playerCoordinates[players[2].name] = (0, 6)
            maze[0][6] = AdvancedMapTile(type: MapTileType.player)
        }
        if (players.count >= 4) {
            playerCoordinates[players[3].name] = (6, 0)
            maze[6][0] = AdvancedMapTile(type: MapTileType.player)
        }
    }
    
    private func setEnergyCounter(_ players: [Player]) {
        for player in players {
            playerEnergy[player.name] = player.hero.energy
        }
    }
    
    private static func generateMaze() -> [[MapTile]] {
        return [
            [AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty)],
            
            [AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.teleport), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty)],
            
            [AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty)],
            
            [AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty)],
            
            [AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty)],
            
            [AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.rock), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.teleport), AdvancedMapTile(type: MapTileType.empty)],
            
            [AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty),AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty), AdvancedMapTile(type: MapTileType.empty)]
        ]
    }
    
}

extension Array where Element : Collection,
Element.Iterator.Element == MapTile, Element.Index == Int {
    
    func getSomePortalCoordinates(of x: MapTileType, current: (Int, Int)) -> (Int, Int)? {
        for (i, row) in self.enumerated() {
            if let j =  row.firstIndex(where: {$0.type == x}) {
                if (i != current.0 || j != current.1) {
                    return (i, j)
                }
            }
        }
        return nil
    }
}
