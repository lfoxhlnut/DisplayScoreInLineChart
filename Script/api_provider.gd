extends Label
@onready var microsoft_office = $ApiOption/MicrosoftOffice
@onready var wps_office = $ApiOption/WPSOffice

var api_provider: String:
	get:
		if microsoft_office.button_pressed:
			return 'ms'
		else:
			return 'wps'
