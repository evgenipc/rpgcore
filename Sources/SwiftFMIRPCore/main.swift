
var mapGenerator = AdvancedMapGenerator()
var playerGenerator = DefaultPlayerGenerator(heroGenerator: DefaultHeroGenerator())
var figthGenerator = DefaultFightGenerator()
var equipmentGenerator = DefaultEquipmentGenerator()
var mapRendered = AdvancedMapRenderer()
var game = Game(mapGenerator: mapGenerator, playerGenerator: playerGenerator, mapRenderer: mapRendered)

game.run()
