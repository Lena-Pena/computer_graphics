import QtQuick 2.2


Item
{
    id: root;

    //use this params instead of common width|height to set geomtry
    property int sliderWidth: 280
    property int sliderHeight: 11
    property int captionWidth: 40 + 4 * captionPrecision
    property int captionHeight: 10
    property int captionSpacing: 5
    

    property int captionPrecision: 2
    property int captionPrecisionPow10: Math.pow(10, captionPrecision)

    property alias minimum: slider.minimum
    property alias maximum: slider.maximum

    property alias value_min:   slider.value_min
    property alias value_max:   slider.value_max

    property alias discrete: slider.discrete
    property real step: 1
    property alias discretePartLength: slider.discretePartLength

    property bool showCaption: true;
    property bool captionInDegrees: false;

    //exponential slider
    property real   exponentialPixelPart: 0
    property real   exponentialMaxValue: 300
  

    property int amount: 2

    property alias sliderColor: leftRect.color
    property int position: 13
    property bool selected: false
    property bool selectionAllowed: false

    property color handleSelectedColor:     "#fdf900"
    property color handleUnselectedColor:   "#ffffff"

    signal signSelected();
    signal signPositionChanged()

    width:  showCaption ? sliderWidth + captionWidth : sliderWidth;
    height: showCaption ? sliderHeight + captionHeight + captionSpacing : sliderHeight;
    
	TR_Label
    {
        id: caption
        width: parent.captionWidth
        height: parent.captionHeight
        anchors.top: slider.bottom
        anchors.topMargin: captionSpacing
        x: handle1.x + sliderHeight / 2
        text:  getText()
        horizontalAlignment: 4   //выравнивание
        verticalAlignment: 1
        style: 11
        opacity: root.showCaption
    }

    function getText()
    {
        if(captionInDegrees)
        {
            var degrees = Math.floor(slider.value_min) 
            var minutes = (slider.value_min - degrees) * 60.0
            var seconds = Math.floor((minutes - Math.floor(minutes)) * 60.0)

            return  degrees + "°" + Math.floor(minutes) + "\'"  + seconds + "\""
        }
        else
           return Math.round(slider.value_min) 
    }

    function setSliderParams(setMin, setMax)
    {

        slider.minimum = setMin
        slider.maximum = setMax

        if (setMax > setMin) 
		{
            if(slider.value_min < slider.minimum)
            {
                setValue(slider.minimum)
                return;
            }

            if(slider.value_min > slider.value_max)
            {
                setValue(slider.value_max)
                return;
            }

            if(slider.value_max < slider.value_min)
            {
                setValue(slider.value_min)
                return;
            }
            if(slider.value_max > slider.maximum)
            {
                setValue(slider.maximum)
                return;
            }


            var pos1 = 2 + (slider.value_min - setMin) * slider.xMax / (setMax - setMin);
            pos1 = Math.min(pos1, width - handle1.width - 2);
            pos1 = Math.max(pos1, 2);

            var pos2 = 2 + (slider.value_max - setMin) * slider.xMax / (setMax - setMin);
            pos2 = Math.min(pos2, width - handle1.width - 2);
            pos2 = Math.max(pos2, 2);

            handle1.x = pos1 + Math.pow(position);
            handle2.x = pos2 - Math.pow(position);
            console.debug(handle1.x, "setSliderParams1")
        } else {
            handle1.x = slider.xMax + 2;
            setValue(Math.max(setMin, setMax));
            console.debug(handle1.x, "setSliderParams2")
        }
    }


    function setValue(val)
    {
        if(val < slider.minimum)
        {
           slider.value_min = slider.minimum
            slider.updatePos()
            return;
        }
        if(val > slider.maximum)
        {
            slider.value_min = slider.maximum
            slider.updatePos()
            return;
        }
        slider.value_min = Math.floor(val * root.captionPrecisionPow10) / root.captionPrecisionPow10; //can be precision loosing after * operation :(
        slider.updatePos()

        //console.debug("setValue")
    }


    Item {
        id: slider;
        width: sliderWidth; height: sliderHeight

        anchors
        {
            centerIn: parent
        }

        property real value_min: 1
        property real value_max: 1
        property real maximum: 1
        property real minimum: 1
        property int xMax: width - handle1.width - 4
        property bool discrete: false
        property real discretePartLength: step ? xMax / ((maximum-minimum) / step) : 1
        onXMaxChanged: updatePos();
        //onMinimumChanged: updatePos();
        //onMaximumChanged: updatePos();

        function updatePos() {
            if (slider.maximum > slider.minimum)
            {
                var pos1 = 0

                if(exponentialPixelPart)
                {
                    if(slider.value_min < exponentialMaxValue)
                        pos1 = 2 + Math.pow((slider.value_min - slider.minimum) / exponentialMaxValue, 0.769) * (slider.xMax * exponentialPixelPart);
                    else
                        pos1 = 2 + slider.xMax * exponentialPixelPart + (slider.value_min - exponentialMaxValue) * (slider.xMax * (1 - exponentialPixelPart)) / (slider.maximum - exponentialMaxValue);
                }
                else
                {
                    pos1 = 2 + (slider.value_min - slider.minimum) * slider.xMax / (slider.maximum - slider.minimum);
                }

                pos1 = Math.min(pos1, width - handle1.width - 2);
                pos1 = Math.max(pos1, 2);
                handle1.x = pos1;
                //console.debug(handle1.x, "updatepos1")
            }
            else
            {
                handle1.x = xMax + 2;
                //console.debug(handle1.x, "updatepos2")
            }


            if (slider.maximum > slider.minimum)
            {
                pos1 = 0

                if(exponentialPixelPart)
                {
                    if(slider.value_max < exponentialMaxValue)
                        pos1 = 2 + Math.pow((slider.value_max - slider.minimum) / exponentialMaxValue, 0.769) * (slider.xMax * exponentialPixelPart);
                    else
                        pos1 = 2 + slider.xMax * exponentialPixelPart + (slider.value_max - exponentialMaxValue) * (slider.xMax * (1 - exponentialPixelPart)) / (slider.maximum - exponentialMaxValue);
                }
                else
                {
                    pos1 = 2 + (slider.value_max - slider.minimum) * slider.xMax / (slider.maximum - slider.minimum);
                }

                pos1 = Math.min(pos1, width - handle1.width - 2);
                pos1 = Math.max(pos1, 2);
                handle2.x = pos1;
                //console.debug(handle1.x, "updatepos1")
            }
            else
            {
                handle2.x = xMax + 2;
                //console.debug(handle1.x, "updatepos2")
            }
        }

        Rectangle {  //  Средняя закрашенная в синий цвет середина между 2 маркерами ползунков
            anchors.fill: parent
            color: "#008287"
        }

        Rectangle {  //  Левый квадрат
            id: leftRect;
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: handle1.left
            color: "#6c6c6c"
        }

        Rectangle {  //  Правый квадрат
            id: middleRect;
            anchors.left: handle2.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            color: "#6c6c6c"
        }

        Rectangle {  //  Ползун1
            id: handle1;
            width: slider.height; height: slider.height;
            color: handleUnselectedColor

            MouseArea {
                id: handleMouseArea1
                anchors.fill: parent; 
				drag.target: parent
                drag.axis: Drag.XAxis
                drag.minimumX: slider.maximum > slider.minimum ? 2 : slider.xMax + 2
                drag.maximumX: handle2.x;
                onPositionChanged:
                {
                    if(exponentialPixelPart)
                    {
                        if(handle1.x-2 < exponentialPixelPart * slider.xMax)
                            slider.value_min = slider.minimum + exponentialMaxValue * ( Math.pow(((handle1.x-2) / (exponentialPixelPart * slider.xMax)), 1.3) );
                        else
                            slider.value_min = exponentialMaxValue + (slider.maximum - exponentialMaxValue) * (handle1.x - 2 - slider.xMax * exponentialPixelPart) / (slider.xMax * (1 - exponentialPixelPart));
                    }
                    else
                    {
                        if(discrete)
                        {
                            handle1.x = Math.ceil((handle1.x-2) / slider.discretePartLength) * slider.discretePartLength + 2;
                        }

                        slider.value_min = (slider.maximum - slider.minimum) * (handle1.x - 2) / slider.xMax + slider.minimum;
                    }
                    slider.value_min = Math.floor(slider.value_min * root.captionPrecisionPow10) / root.captionPrecisionPow10;
                    if (handle1.x > handle2.x - position)
                    {
                        handle1.x= handle2.x - position
                        slider.value_min= slider.value_max 
                    }
                    signPositionChanged()
                }

                onPressed:
                {
                    if(selectionAllowed && !root.selected)
                    {
                        root.selected = true;
                        root.signSelected();
                    }
                }
            }
        }

        Text {
            id: text2;
            text: Number(Math.round(slider.value_max));
            font.family: "Helvetica";
            font.pointSize: 10;
            color: "white";
            anchors.bottom: handle2.top;
            x: handle2.x
        }

        Rectangle {  //  Ползун2
            id: handle2;
            width: slider.height;
            height: slider.height;
            color: handleUnselectedColor

            MouseArea {
                id: handleMouseArea2
                anchors.fill: parent;
                drag.target: parent
                drag.axis: Drag.XAxis
                drag.minimumX: handle1.x;
                drag.maximumX: slider.xMax + 2
                onPositionChanged:
                {
                    if(exponentialPixelPart)
                    {
                        if(handle2.x-2 < exponentialPixelPart * slider.xMax)
                            slider.value_max = slider.value_min + exponentialMaxValue * ( Math.pow(((handle2.x-2) / (exponentialPixelPart * slider.xMax)), 1.3) );
                        else
                            slider.value_max = exponentialMaxValue + (slider.maximum - exponentialMaxValue) * (handle2.x - 2 - slider.xMax * exponentialPixelPart) / (slider.xMax * (1 - exponentialPixelPart));
                    }
                    else
                    {
                        if(discrete)
                        {
                            handle2.x = Math.ceil((handle2.x-2) / slider.discretePartLength) * slider.discretePartLength + 2;
                        }
                        slider.value_max = (slider.maximum - slider.minimum) * (handle2.x - 2) / slider.xMax + slider.minimum;
                    }
                    slider.value_max = Math.floor(slider.value_max * root.captionPrecisionPow10) / root.captionPrecisionPow10;
                    if (handle2.x < handle1.x + position)
                    {
                        handle2.x= handle1.x + position
                        slider.value_max= slider.value_min 
                    }
                    signPositionChanged()
                }

                onPressed:
                {

                    if(selectionAllowed && !root.selected)
                    {
                        root.selected = true;
                        root.signSelected();
                    }
                }
            }
        }

    }
}
