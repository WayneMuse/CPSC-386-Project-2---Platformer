extends Node2D

@onready var hazard_tilemap: TileMap = $HazardMap
@onready var coin_tilemap: TileMap = $CoinMap

@export var spike_hazard_scene: PackedScene
@export var coin_scene: PackedScene

func _ready():
	# === Spawn Hazards ===
	var hazard_tiles = hazard_tilemap.get_used_cells(0)
	for tile_pos in hazard_tiles:
		var world_pos = hazard_tilemap.map_to_local(tile_pos)
		var hazard = spike_hazard_scene.instantiate()
		hazard.global_position = world_pos
		get_parent().call_deferred("add_child", hazard)
	hazard_tilemap.hide()

	# === Spawn Coins ===
	var coin_tiles = coin_tilemap.get_used_cells(0)
	for tile_pos in coin_tiles:
		var world_pos = coin_tilemap.map_to_local(tile_pos)
		var coin = coin_scene.instantiate()
		coin.global_position = world_pos
		get_parent().call_deferred("add_child", coin)
	coin_tilemap.hide()
