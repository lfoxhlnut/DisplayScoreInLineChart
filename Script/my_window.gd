extends Panel

signal closed
signal canceled
signal confirmed

# 这里换一个方式比较好
# 不知道 gd4 支不支持反射
# 或者这里也应该写 setter 的
@export var hide_confirm_button := false
@export var hide_cancel_button := false
@export var hide_close_button := false


@export var confirm_text := '':
	set(val):
		confirm_text = val
		if _readyed:
			confirm.text = val	# gd4 还是没解决这个问题啊, 那写法又要变得丑陋了

@export var cancel_text := '':
	set(val):
		cancel_text = val
		if _readyed:
			cancel.text = val

var _readyed := false

@onready var close = $Close
@onready var confirm = $Confirm
@onready var cancel = $Cancel

func _ready():
	
	_readyed = true
	cancel_text = cancel_text
	confirm_text = confirm_text
	
	
	if hide_confirm_button:
		confirm.hide()
	if hide_cancel_button:
		cancel.hide()
	if hide_close_button:
		close.hide()


# 并没有写可以让它们在运行时显示或隐藏的方法


func _on_close_pressed():
	hide()
	closed.emit()


func _on_confirm_pressed():
	# 这里似乎必须要先 hide() 再 emit()
	# 因为如果先 emit() 了, 又有一个函数接收到了 confirmed 这个信号, 并且这个函数调用 my_window.show()
	# 那么好像不能确定是先执行 emit() 后的 hide() 还是上面提到的函数中调用的 show()
	# 根据我的实验, 好像会先执行 show(), 于是 show() 就被 hide() 覆盖掉了, 不清楚为什么
	hide()
	confirmed.emit()


func _on_cancel_pressed():
	hide()
	canceled.emit()

