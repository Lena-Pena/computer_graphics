import QtQuick 2.2


Rectangle {
    property int sideBarWidth:220

    id: root
    width: extern_screenWidth        //задание геометрических параметров, т.е. высоты и ширины
    height: extern_screenHeight
    color: "#000000"

   TR_Label
   {
       id: versionLabel
       width: 70
       height: 17

       anchors.bottom: parent.bottom
       anchors.right: parent.right
       text: "v 0.1beta"
       style: 11
   }

   Rectangle
   {
       id: sidebarFrame
       width: slider.value
       color: "#26edf7"
       anchors.top: parent.top
       anchors.bottom: parent.bottom
       anchors.left: parent.left
   }

   Rectangle
   {
       id: sliderForm

       width: 280
       height: 70

       border.color: "#ffffff"
       border.width: 1
       color: "#1d1d1d"
       anchors
       {
           left: sidebarFrame.right
           top: parent.top
       }

       TR_Slider
       {
           id: slider
           anchors.centerIn: parent

           sliderWidth: 250

           minimum: 0
           maximum: 100
           value: 50
       }
   }
   Rectangle
   {
       id: newFrame
       width: sliderW.value
       height: sliderH.value
       color: "#c33cb3"
       anchors.top: sliderForm.bottom
       anchors.left: sidebarFrame.right
   }

   Rectangle
   {
       id: sliderFormW

       width: 280
       height: 70

       border.color: "#ffffff"
       border.width: 1
       color: "#1d1d1d"
       anchors
       {
           left: sidebarFrame.right
           top: newFrame.bottom
       }

       TR_Slider
       {
           id: sliderW
           anchors.centerIn: parent

           sliderWidth: 250

           minimum: 0
           maximum: 100
           value: 80
       }
   }
   Rectangle
   {
       id: sliderFormH

       width: 280
       height: 70

       border.color: "#ffffff"
       border.width: 1
       color: "#1d1d1d"
       anchors
       {
           left: sidebarFrame.right
           top: sliderFormW.bottom
       }

       TR_Slider
       {
           id: sliderH
           anchors.centerIn: parent
		   
           sliderWidth: 250
		   
           minimum: 0
           maximum: 100
           value: 90
       }
   }
   Rectangle
   {
       id: slider2Frame
       width:280
       height:70
       border.color:"#ffffff"
       border.width:1
       color:"#1d1d1d"
       anchors
       {
           left:sidebarFrame.right
           top:sliderFormH.bottom
       }
       SliderMinMax
       {
           id:sliderMM
           anchors.centerIn:parent
           sliderWidth: 250
           minimum: 0
           maximum: 100
           value_min: 50
           value_max: 95
       }
   }
   Rectangle
   {
       id:new2Frame
       width: sliderMM.value_min
       height: sliderMM.value_max
       color:"#f0fb50"
       anchors.top:slider2Frame.bottom
       anchors.left:sidebarFrame.right
   }
}
