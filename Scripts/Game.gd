extends Node2D

# Actual level tiles
var level_grid

# Customizable level data
export (int) var grid_width = 5
export (int) var grid_height = 3
export (int) var x_start = 90
export (int) var y_start = 90
export (int) var x_off = 165
export (int) var y_off = 165

# Keep up with the player tile
var player

# Loading the tiles that will be used
var tiles = [
	preload("res://Scenes/DefaultTile.tscn"),
	preload("res://Scenes/Player.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Initialize the grid to all default tiles
	level_grid = []
	for i in range(grid_width):
		level_grid.append([])
		for j in range(grid_height):
			level_grid[i].append(0)
			
	# This function will do more when there are more tile types
	draw_level()
	
	# Initialize the player object
	player = tiles[1].instance()
	
	# Add the player to the game
	add_child(player)
	
	# Set position and player variables
	var player_position = grid_to_pixel(0, 0)
	player.position = Vector2(player_position[0], player_position[1])
	player.grid_x = 0
	player.grid_y = 0

# Check for input every frame
func _process(delta):
	check_input()
		
# Convert grid coordinates to pixel values
func grid_to_pixel(x, y):
	return Vector2(x * x_off + x_start, y * y_off + y_start)
		
# Draw each tile in the level grid
func draw_level():
	for i in range(grid_width):
		for j in range(grid_height):
			if (level_grid[i][j] == 0):
				var tile = tiles[0].instance()
				add_child(tile)
				var pos = grid_to_pixel(i, j)
				tile.position = Vector2(pos[0], pos[1])
				
func check_input():
	# Calculate the direction the player is trying to go
	var dir = Vector2(0, 0)
	
	if (Input.is_action_just_pressed("ui_right")):
		dir = Vector2(1, 0)
	elif (Input.is_action_just_pressed("ui_left")):
		dir = Vector2(-1, 0)
	elif (Input.is_action_just_pressed("ui_up")):
		dir = Vector2(0, -1)
	elif (Input.is_action_just_pressed("ui_down")):
		dir = Vector2(0, 1)
	
	# Move the player to the new position
	if (dir != Vector2(0, 0)):
		var target = Vector2(player.grid_x + dir[0], player.grid_y + dir[1])
		player.position = grid_to_pixel(target[0], target[1])
		player.grid_x = target[0]
		player.grid_y = target[1]
	
	# Set direction back to nothing
	dir = Vector2(0, 0)
