extends Node2D


enum PotatoState {WAITING, GROWING, REVIVING, DEAD, FINISHED}


export var base_speed = 200 # how fast the player moves without boost (pixels / second)
export var rotation_speed = 5 # how fast the player rotates (radians / second)
export var base_line = 15 # how far below the start position the root starts (pixels)
export var track_distance = 5 # length of a single straight segment of the track used for backtracking (pixels)
export var return_speed = 300 # how fast the player moves backwards after hitting something (pixels / second)
var state = PotatoState.WAITING
var control
var index
var nitro_active = false
var bonus_gain = 0
var root
var track = PoolVector2Array()
var target_id
var progress = 0

const wrap_width = 2048 # todo: put this in a more global location

var Root = preload("res://scenes/Root.tscn")
var Flower = preload("res://scenes/Flower.tscn")

var hats = [
	preload("res://scenes/hats/Hat0.tscn"),
	preload("res://scenes/hats/Hat1.tscn"),
	preload("res://scenes/hats/Hat2.tscn"),
	preload("res://scenes/hats/Hat3.tscn")
]


func _ready():
	pass


func start_growing():
	state = PotatoState.GROWING
	start_new_root([Vector2(0, base_line)])

func set_id_index(control_id, index):
	control = PlayerInputs.get_control(control_id)
	self.index = index
	for icon in $Tip/Sprites.get_children():
		icon.queue_free()
	$Tip/Sprites.add_child(hats[index].instance())


func die():
	if state == PotatoState.DEAD:
		return

	state = PotatoState.DEAD

	# if $'/root/World/SND_PlayerDeath'.is_playing():
		# $'/root/World/SND_PlayerDeath'.stop();
	$'/root/World/SND_PlayerDeath'.play();

	Global.add_player_dead(index)

func finish():
	if state == PotatoState.FINISHED:
		return

	state = PotatoState.FINISHED

	Global.add_player_finished(index)

	var flower = Flower.instance()

	flower.global_position = $Tip.global_position
	flower.scale.x = 1.1 - Global.players_finished * 0.2
	flower.scale.y = flower.scale.x

	get_node("/root/World/Potatoes").add_child(flower)

	flower.play()

func y_position():
	return $Tip.global_position.y

func is_nitro_active():
	return nitro_active

func set_bonus_gain(bonus):
	bonus_gain = bonus

func start_new_root(old_points=[]):
	root = Root.instance()
	# root.start_progress = current_progress()

	old_points = old_points.duplicate()
	old_points.push_back($Tip.position)

	var progress = [current_progress()]
	for i in range(old_points.size()-1, -1, -1):
		progress.push_front(progress[0] - old_points[i].distance_to(old_points[i-1]))
	for i in range(old_points.size()):
		root.extend(old_points[i], progress[i])
	$Roots.add_child(root)


func current_progress():
	return progress


func _physics_process(delta):
	if state == PotatoState.GROWING:
		var inp = control.move_direction()
		$Tip.rotation += inp * delta * rotation_speed
		var current_speed = base_speed
		var vel = Vector2(0, -current_speed).rotated($Tip.rotation)
		$Tip.position += vel * delta
		progress += (vel * delta).length()

		root.extend($Tip.position, progress)

		var wrapped = false
		if $Tip.global_position.x < 0:
			$Tip.position.x += wrap_width
			wrapped = true
		elif $Tip.global_position.x >= wrap_width:
			$Tip.position.x -= wrap_width
			wrapped = true
		if wrapped:
			root.finish()
			start_new_root()
		if root.should_split():
			start_new_root()

		if track.empty() or track[track.size() -1 ].distance_to($Tip.position) > track_distance:
			track.push_back($Tip.position)
	elif state == PotatoState.REVIVING:
		var d = return_speed * delta
		progress -= d
		var target = get_target()
		while target != null and d > $Tip.position.distance_to(target):
			d -= $Tip.position.distance_to(target)
			$Tip.position = target
			track.resize(track.size() - 1)
			target = get_target()
		if target == null:
			die()
			return
		$Tip.rotation = target.angle_to_point($Tip.position) - PI / 2
		$Tip.position = $Tip.position.move_toward(target, d)
		if $Tip.global_position.x < 0:
			$Tip.position.x += wrap_width
		elif $Tip.global_position.x > wrap_width:
			$Tip.position.x -= wrap_width

		if control.any_key_just_pressed():
			state = PotatoState.GROWING
			start_new_root()


func get_target():
	if track.empty():
		return null
	var target = track[track.size() - 1]
	if target.x > $Tip.position.x + wrap_width / 2:
		target.x -=  wrap_width
	if target.x < $Tip.position.x - wrap_width / 2:
		target.x +=  wrap_width
	return target

func collide_solid(body):
	if state == PotatoState.GROWING:
		state = PotatoState.REVIVING
		root.finish()
		root = null

		if $'/root/World/SND_PlayerCollide'.is_playing():
			$'/root/World/SND_PlayerCollide'.stop();
		$'/root/World/SND_PlayerCollide'.play();



func _on_Hitbox_body_entered(body):
	collide_solid(body)
