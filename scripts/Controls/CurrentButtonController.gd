class_name CurrentButtonController
extends Node

@export var buttons: Array[MenuBtn]

var current: int = 0
var process_input:bool = false

func _ready():
	buttons[current].make_selected()
	for button in buttons:
		button.mouse_made_selected.connect(self.on_mouse_selected)

func set_current(index: int):
	if index < 0 or index > len(buttons):
		return
	if index == current:
		return
	current = index
	var btn = buttons[current]
	btn.make_selected()
	for button in buttons:
		if button == btn:
			continue
		button.make_deselected()

func on_mouse_selected(button: MenuBtn):
	var index = buttons.find(button, 0)
	if index == current:
		return
	if index != -1:
		current = index
		button.make_selected()
		for generic_btn in buttons:
			if generic_btn == button:
				continue
			generic_btn.make_deselected()

func move_down():
	var length = len(buttons)
	var next = current + 1
	if next > length - 1:
		next = 0
	buttons[current].make_deselected()
	buttons[next].make_selected()
	current = next

func move_up():
	var length = len(buttons)
	var next = current - 1
	if next < 0:
		next = length - 1
	buttons[current].make_deselected()
	buttons[next].make_selected()
	current = next

func _process(delta):
	if process_input:
		if Input.is_action_just_pressed("down"):
			move_down()
		
		if Input.is_action_just_pressed("up"):
			move_up()
		
		if Input.is_action_just_pressed("accept"):
			buttons[current].pressed.emit()
