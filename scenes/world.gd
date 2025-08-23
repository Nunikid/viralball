extends Node

@export var whitecell_scene: PackedScene
@export var bloodcell_scene: PackedScene
var score

func _ready():
	new_game()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
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
