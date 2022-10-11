import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: root

    function getData(str) {
//        listview.model.clear()
        var xmlhttp = new XMLHttpRequest();
        var url = str; // Идентификатор ресурса
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == XMLHttpRequest.DONE && xmlhttp.status == 200) {
                print(xmlhttp.responseText)
                result.text=xmlhttp.responseText;
            }
        }

     xmlhttp.open("GET", url, true);
     xmlhttp.send();
    }    

    function findElement(myModel, myId) {
        for(var i = 0; i < myModel.count; i++) {
            var element = myModel.get(i);
            if(myId == element.key) {
                return element.query;
            }
        }
        return "";
    }

    width: 505
    height: 480
    visible: true
    title: qsTr("Numberic World")

    Item{
        anchors.fill: parent
        ListModel {
            id: modelType
            ListElement { key:0; query:"";       ru:"-"}
            ListElement { key:1; query:"/trivia"; ru:"Мелочи"}
            ListElement { key:2; query:"/year";   ru:"Год"}
            ListElement { key:3; query:"/date";   ru:"Дата"}
            ListElement { key:4; query:"/math";   ru:"Математика"}
        }

        ListModel {
            id: modelQuery
            ListElement { key:0; query:"?";                               view:"-"}
            ListElement { key:1; query:"?json&";                          view:"json"}
            ListElement { key:2; query:"";                                view:"партия"}
            ListElement { key:3; query:"?min=${num1}&max={num2}";  view:"Между min и max"}
            ListElement { key:4; query:"?write&";                         view:"вызов"}
        }

        Column {
          id: col1
          x:5
          y:10
          width: parent.width
          height: 40

          Text {
              id: textQuery
              text: "Типы запроса:";
              //width: parent.width
              height: parent.height
              //x: parent.x
              anchors.horizontalCenter: parent.horizontalCenter
              //y: parent.y
              font.pointSize: 14
              font.family: "Courier"
              font.italic: true
              font.bold: true
//              padding: 10
//              bottomPadding: 0
          }

            Row {
                  id: row1
                  x: parent.x
                  width: parent.width
                  height: parent.height

                  ComboBox {
                      id: selectType
                      model: modelType
                      currentIndex: 0
                      textRole: "ru"
                      x: parent.x
                      //y: parent.y
                      width: 150
                      height: parent.height
                      background: Rectangle {
                          color:"white"
                          border.width: parent && parent.activeFocus ? 2 : 1
                          border.color: parent && parent.activeFocus ? selectType.palette.highlight : selectType.palette.button
                      }
                  }

                  ComboBox {
                      id: selectQuery
                      model: modelQuery
                      currentIndex: 0
                      textRole: "view"
                      x: selectType.x + selectType.width
                      //y: parent.y
                      width: 150
                      height: parent.height
                      background: Rectangle {
                          color:"white"
                          border.width: parent && parent.activeFocus ? 2 : 1
                          border.color: parent && parent.activeFocus ? selectQuery.palette.highlight : selectQuery.palette.button
                      }
                  }

                  TextField {
                      id: defaul
                      placeholderText: "Что ответить?"
                      width: 190
                      height: parent.height
                      font.pointSize: 14
                      font.family: "Courier"
                      font.italic: true
                      font.bold: true
                  }
            }

            Text {
                id: textNum
                text: "Числа:";
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                //x: parent.x
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
//                padding: 10
                topPadding: 10
            }

            Row {
                id: row2
                x: parent.x
                width: parent.width
                height: parent.height

                TextField {
                    id: nMin
                    placeholderText: "random /1/1..3/1..3,10"
                    width: 300
                    height: parent.height
                    font.pointSize: 14
                    font.family: "Courier"
                    font.italic: true
                    font.bold: true
                }

                TextField {
                    id: nMax
                    placeholderText: "10"
                    width: 150
                    height: parent.height
                    font.pointSize: 14
                    font.family: "Courier"
                    font.italic: true
                    font.bold: true
                }
            }

            Button {
                id:select
                text: "Результат"
                width: parent.width
                height: parent.height
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true

                onClicked: {
                    result.text="";
                    var num_1 = ( nMin.text == "" ? "random" : nMin.text);
                    var num_2 = ( nMax.text == "" ? "random" : nMax.text);
                    var strquery="http://numbersapi.com/"
                    if (selectQuery.currentIndex == 3) {   // min&max
                        strquery +="random"+findElement(modelType, selectType.currentIndex);
                        var t="?min="+num_1+"&max="+num_2;
                        strquery += t;
                    } else if (selectQuery.currentIndex == 2) { // batch
                        strquery += num_1 + "," + num_2 + "?default=" + defaul.text;
                    } else {
                        strquery += num_1+findElement(modelType, selectType.currentIndex)+
                                findElement(modelQuery, selectQuery.currentIndex);
                        if (defaul.text!="") strquery +="default=" + defaul.text;
                    }
                    console.log(strquery);
                    getData(strquery);
                }
            }

            TextEdit {
                id: result
                text: ""
                width: parent.width
                height: 250
                topPadding: 5
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                wrapMode: TextEdit.WordWrap
            }
        }
    }
}
