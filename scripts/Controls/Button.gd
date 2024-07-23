class_name MenuBtn
extends Button

signal mouse_made_selected(MenuBtn)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func make_selected():
	text = ">" + text + "<"

func make_deselected():
	text = text.replace(">", "").replace("<", "")

func _on_mouse_entered():
	mouse_made_selected.emit(self)


#func _on_mouse_exited():
	#make_deselected()
