extends Node

@export var whitecell_scene: PackedScene
@export var bloodcell_scene: PackedScene
@export var PlayerScene: PackedScene
@export var StartPositions: Array[Node2D]

var score
var players = {}

func _ready():
	new_game()

func new_game():
	score = 0
	for p in players.values():
		p.queue_free()
	players.clear()
	spawn_player(1, StartPositions[0].position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("white_cells", "queue_free")
	get_tree().call_group("blood_cells", "queue_free")

func _on_player_hit() -> void:
	$ScoreTimer.stop()
	$WhiteCellTimer.stop()
	$BloodCellTimer.stop()
	$HUD.show_game_over()
	
func spawn_player(id: int, pos: Vector2):
	var player = PlayerScene.instantiate()
	add_child(player)
	player.global_position = pos
	player.name = "Player_%s" % id
	players[id] = player
	
	player.hit.connect(_on_player_hit)
	player.blood_collected.connect(_on_player_blood_collected)

func _on_white_cell_timer_timeout() -> void:
	var white_cell = whitecell_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	white_cell.position = mob_spawn_location.position
	var direction = mob_spawn_location.rotation + PI / 2

	direction += randf_range(-PI / 4, PI / 4)
	white_cell.rotation = direction
	white_cell.add_to_group("white_cells")
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	white_cell.linear_velocity = velocity.rotated(direction)
	add_child(white_cell)

func _on_start_timer_timeout() -> void:
	$WhiteCellTimer.start()
	$BloodCellTimer.start()
	$ScoreTimer.start()

func _on_score_timer_timeout() -> void:
	pass
	
func _on_blood_cell_timer_timeout() -> void:
	var blood_cell = bloodcell_scene.instantiate()
	blood_cell.add_to_group("blood_cells")
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	blood_cell.position = mob_spawn_location.position
	var direction = mob_spawn_location.rotation + PI / 2

	direction += randf_range(-PI / 4, PI / 4)
	blood_cell.rotation = direction

	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	blood_cell.linear_velocity = velocity.rotated(direction)
	add_child(blood_cell)


func _on_player_blood_collected(points: int) -> void:
	$ConsumeSound.pitch_scale = randf_range(0.8,1.2)
	$ConsumeSound.play()
	score += points
	$HUD.update_score(score)
