extends Control


@export_file("*.json") var d_file#pour renomer tous les fichier mis dans la variable
var dialogue = []
var current_dialogue_id = 0
var dialogue_is_active =false
func _ready():
	start()

func start():
	dialogue = load_dialogue()
	current_dialogue_id = -1
	next_script()

#on extrait le dialogue qui provient du fichier dialogue.json 
func load_dialogue():
	var file = FileAccess.open("res://dialogue/Gravekeeper_dialogue.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content
	
	
func _input(event: InputEvent):#passer au dialogue suivant si touche préssé
	if event.is_action_pressed("ui_accept"):
		next_script()
func next_script():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue):
		return
	$NinePatchRect/Name.text = dialogue[current_dialogue_id]['name']
	$NinePatchRect/Text.text = dialogue[current_dialogue_id]['text']
	
