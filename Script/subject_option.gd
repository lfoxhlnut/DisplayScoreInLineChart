extends GridContainer


var subject_button_group := ButtonGroup.new()
var selected_subject_id := 0


func _ready():
	columns = floori(sqrt(Constant.SUBJECT_NUM))
	for i in Constant.SUBJECT_NUM:
		var check_box := CheckBox.new()
		check_box.text = Constant.SUBJECT_NAME[i] as String
		check_box.button_group = subject_button_group
		check_box.pressed.connect(func(): selected_subject_id = i)
		add_child(check_box)
	get_child(0).button_pressed = true


func _exit_tree():
	Constant.remove_and_free(self)
