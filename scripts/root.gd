extends StaticBody2D


export var segment_distance = 5
export var collision_radius = 10
var collision_offset = 5

var latest_position
var collision_queue = []

func extend(pos):
	latest_position = pos
	if is_empty() or pos.distance_to(last_point()) >= segment_distance:
		add_point(pos)

	if collision_queue.size() != 0 and collision_queue[0].position.distance_to(pos) > collision_radius + collision_offset:
		add_child(collision_queue.pop_front())

func finish():
	add_point(latest_position)
	for collision in collision_queue:
		call_deferred("add_child", collision)
	collision_queue = []

func add_point(pos):
	$Line.add_point(pos)
	var obstacleShape = CollisionShape2D.new()
	obstacleShape.shape = CircleShape2D.new()
	obstacleShape.position = pos
	obstacleShape.shape.radius = collision_radius
	collision_queue.push_back(obstacleShape)


func is_empty():
	return $Line.get_point_count() == 0

func last_point():
	return $Line.get_point_position($Line.get_point_count() - 1)
