extends Node

var INTERFACE_FILE_PATH := OS.get_executable_path().get_base_dir() + '/Interface.exe'
var SAVE_DIR_PATH := Constant.SAVE_DIR_PATH
const EXECUTE_SUCCESSFULLY_CODE := 0
const DELIMITER: Array[String] = ['\r\n', '\n', '\r']	# 后面的分隔符不能包含前面的
@export var use_binary_file := false

func _ready():
	if OS.has_feature('editor'):
		if use_binary_file:
			INTERFACE_FILE_PATH = ProjectSettings.globalize_path('res://Binary/interface.exe')
		else:
			INTERFACE_FILE_PATH = 'python ' + ProjectSettings.globalize_path('res://Interface/interface.py')



func print_order(arguments: Array):
	var order := ''
	for i in arguments:
		order += str(i) + ' '
	print_debug("order received: ", order)


func parse_output(output: String) -> Array[String]:
	var delimiter: String
	
	for i in DELIMITER:
		if output.contains(i):
			delimiter = i
			break
#	return (output.split(delimiter) as Array[String])	# 这句应该有用, 但是没用, 不知道为什么
	
	var result: Array[String] = []
	for i in output.split(delimiter, false):
		result.append(i)
	return result


func new_class(my_class_name: String, data_file_path: String) -> int:
	var arguments := [SAVE_DIR_PATH, 'nc', my_class_name, data_file_path]
	print_order(arguments)
	
	return OS.execute('powershell', [INTERFACE_FILE_PATH] + arguments)


func new_test(my_class_name: String, test_name: String, data_file_path: String, geo_bio_point_scale: int) -> int:
	var arguments := [SAVE_DIR_PATH, 'nt', my_class_name, test_name, data_file_path, geo_bio_point_scale]
	print_order(arguments)
	
	return OS.execute('powershell', [INTERFACE_FILE_PATH] + arguments)


func get_class_name_table() -> Array[String]:
	var arguments := [SAVE_DIR_PATH, 'gc']
	print_order(arguments)
	
	var output := []
	OS.execute('powershell', [INTERFACE_FILE_PATH] + arguments, output)
	return parse_output(output[0])
 

func get_test_name_table(my_class_name: String) -> Array[String]:
	var arguments := [SAVE_DIR_PATH, 'gt', my_class_name]
	print_order(arguments)
	
	var output := []
	OS.execute('powershell', [INTERFACE_FILE_PATH] + arguments, output)
	return parse_output(output[0])


func get_student_name_table(my_class_name: String) -> Array[String]:
	var arguments := [SAVE_DIR_PATH, 'gsn', my_class_name]
	print_order(arguments)
	
	var output := []
	OS.execute('powershell', [INTERFACE_FILE_PATH] + arguments, output)
	return parse_output(output[0])


func get_student_score_of_all_subject(
		my_class_name: String,
		test_name: String,
		stu_name: String) -> Array[int]:
	var arguments := [SAVE_DIR_PATH, 'gsc', my_class_name, test_name, stu_name]
	print_order(arguments)
	
	var output := []
	OS.execute('powershell', [INTERFACE_FILE_PATH] + arguments, output)
	var parsed_output := parse_output(output[0])
	var int_output: Array[int] = []
	for i in parsed_output.size():
		int_output.append(int(parsed_output[i]))
	return int_output


func export(
	my_class_name: String,
	mask: Array[int],
	sub_id: int,
	stu_name: String,
	export_dir_path: String,
	export_file_name_without_suffix: String,
	export_format: String,
	geo_bio_point_scale: int,
	api_provider: String
	) -> int:
	
	var mask_str: String = str(mask[0])
	for i in range(1, mask.size()):
		mask_str += ',' + str(mask[i])
	
	# 传递给程序的参数可以是非字符串类型, 最终都会变成字符串, 行为大概和你把这个参数 print 出来一样
	# 血的教训, 如果你运行了一个命令但是他没结束, godot 就会等待(具体行为见文档)
	# 你可能会以为 godot 卡了, 就把 debug 版本强行关掉, 但是他调用的那个程序不会因此被关掉
	# 可能就一直挂在后台(比如等待用户输入, 你又没让控制台窗口出现, 那就悲催了), 然后你想重新编译那个程序又会提示你被占用.
	var arguments := [SAVE_DIR_PATH, 'ep', my_class_name, mask_str, sub_id, stu_name, export_dir_path, export_file_name_without_suffix, export_format, geo_bio_point_scale, api_provider]
	print_order(arguments)
	
	# execute() 的 命令 里如果含有空格, 会用引号引起来, 所以调用会报错, 但是 argmuents 里的东西就是转换成字符串, 不会加引号
	return OS.execute('powershell', [INTERFACE_FILE_PATH] + arguments)


func del_class(my_class_name: String) -> int:
	var arguments := [SAVE_DIR_PATH, 'dc', my_class_name]
	return OS.execute('powershell', [INTERFACE_FILE_PATH] + arguments)


func del_test(my_class_name: String, test_id: int) -> int:
	var arguments := [SAVE_DIR_PATH, 'dt', my_class_name, test_id]
	return OS.execute('powershell', [INTERFACE_FILE_PATH] + arguments)


func del_all_class():
	Constant.warn(self, '嘻嘻, 这个功能也还没做')
	pass
