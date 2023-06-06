extends TabContainer

var class_info_tmp: Array[ClassInfo] = [
	ClassInfo.new("class 725", ["test 1", "test2"], ['stu1', 'stu2']),
	ClassInfo.new("class bbb", ["test 1", "'test2;.[]'"], ['[stu1赛风;多;[]]', 'stu2']),
	ClassInfo.new("class 中文", ["中文 1", "鳄鱼root"], ['stu1', '中文123'])
]
var class_info: Array[ClassInfo]

@onready var import = $Import
@onready var export = $Export
@onready var help = $Help


func _ready():
	size = Constant.WIN_SIZE
#	OS.center_window()
#	DisplayServer ??
	print(Interface.INTERFACE_FILE_PATH)
	print(Interface.SAVE_DIR_PATH)
	updated()
	pass


func updated():
	var class_name_table := Interface.get_class_name_table()
	class_info.clear()
	for i in class_name_table:
		var t := ClassInfo.new(i)
		t.test_name = Interface.get_test_name_table(i)
		t.student_name = Interface.get_student_name_table(i)
		class_info.append(t)

	import.update(class_info)
	export.update(class_info)
	
