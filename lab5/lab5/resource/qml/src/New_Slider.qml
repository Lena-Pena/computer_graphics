import QtQuick 2.0

// Minimal slider implementation
Rectangle { 
	property int text_value: 5
    property real value: 5         // required
    property int minimumValue: 0  // optional (default INT_MIN)
    property int maximumValue: 20 // optional (default INT_MAX)
    property real stepSize: 1      // optional (default 1)
	property real prev_coord_position: 0
	property real prev_mouse_position: 0
	property int l_height: 30
	property int l_width: 300
}