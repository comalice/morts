@tool
extends Node3D

@export_range(0.001, 50.0) var radius = 1.0:
	set = _set_radius
@export_range(0.001, 50.0) var width = 10.0:
	set = _set_width

var _selected = false

@onready var _parent = get_parent()
@onready var _circle = find_child("FadedCircle3D")


func _ready():
	_update_circle_params()
	if Engine.is_editor_hint():
		return
	MatchSignals.deselect_all.connect(deselect)
	_parent.input_event.connect(_on_input_event)
	_circle.hide()


func select():
	if _selected:
		return
	_selected = true
	if not _parent.is_in_group("selected_units"):
		_parent.add_to_group("selected_units")
	_update_circle_color()
	_circle.show()


func deselect():
	if not _selected:
		return
	_selected = false
	if _parent.is_in_group("selected_units"):
		_parent.remove_from_group("selected_units")
	_circle.hide()


func _set_radius(a_radius):
	radius = a_radius
	_update_circle_params()


func _set_width(a_width):
	width = a_width
	_update_circle_params()


func _update_circle_color():
	_circle.color = Color.GREEN


func _update_circle_params():
	if _circle == null:
		return
	_circle.radius = radius
	_circle.width = width
	_circle.inner_edge_width = width


func _on_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		select()