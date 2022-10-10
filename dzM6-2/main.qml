import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

import StaticVar 1.0

Window {
    id: root

    function findElementIndex(myModel, myId) {
        for(var i = 0; i < myModel.count; i++) {
            var element = myModel.get(i);
            if(myId == element.money) {
                return element.key;
            }
        }
        return "";
    }


    function findElementValue(myModel, myId) {
        for(var i = 0; i < myModel.count; i++) {
            var element = myModel.get(i);
            if(myId == element.key) {
                return element.value;
            }
        }
        return "";
    }

    function roundNumber(number, digits) {
                var multiple = Math.pow(10, digits);
                var rndedNum = Math.round(number * multiple) / multiple;
                return rndedNum;
            }

    function result() {
        var t = fromValueMoney.text * findElementValue(modelMoney, toMoney.currentIndex) / findElementValue(modelMoney,fromMoney.currentIndex);

        print("from=" + fromMoney.currentIndex + " indFrom=" + StaticVar.indFromMoney);
        print("to="+toMoney.currentIndex  + " indTo=" + StaticVar.indToMoney);

        return roundNumber(t,3);
    }

    function getData() {
        StaticVar.setFromMoney(fromMoney.currentIndex);
        StaticVar.setToMoney(toMoney.currentIndex);
        modelMoney.clear()
        var xmlhttp = new XMLHttpRequest();
        var url = "https://cdn.cur.su/api/cbr.json"; // Идентификатор ресурса
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == XMLHttpRequest.DONE && xmlhttp.status == 200) {
                print(xmlhttp.responseText)
                parseMoney(xmlhttp.responseText);

                fromMoney.currentIndex = StaticVar.indFromMoney
                toMoney.currentIndex = StaticVar.indToMoney
            }
        }

     xmlhttp.open("GET", url, true);
     xmlhttp.send();

    }

    function parseMoney(response) {
        var jsonObj = JSON.parse(response);
        var jsonBase = jsonObj.base;
        var jsonRatesKey = Object.keys(jsonObj.rates);
        var jsonSource = jsonObj.source;
        var jsonDate = jsonObj.putISODate;

        for(var i = 0; i < jsonRatesKey.length; i++) {
              modelMoney.append({key:i, money:jsonRatesKey[i], value:jsonObj.rates[jsonRatesKey[i]]});
        }

        var str = jsonDate.split("T");
        var dateParts = str[0].split("-");
//        var dateUp = new Date(dateParts[0], (dateParts[1] - 1), dateParts[2]);
        updateTime.text = String(dateParts[2] + "-" + dateParts[1] + "-"+ dateParts[0]);
        var tempParts = str[1].split("+")
        var timeParts = tempParts[0].split(".");
        updateTime.text +=String(" " + timeParts[0]);
    }

    width: 550
    height: 150
    visible: true
    title: qsTr("Money converter")

    Item{
        anchors.fill: parent
        ListModel {
            id: modelMoney
        }
      Column {
        id: col1
        x:10
        y:10
        width: 500
        height: 40

        Row {
            id: row1
            x: parent.x
            y: parent.y
            width: 500
            height: parent.height

            TextField {
              id: fromValueMoney
              text: "100"
              width: 100
              height: parent.height
              x: parent.x
              //y: parent.y
              font.pointSize: 14
              font.family: "Courier"
              font.italic: true
              font.bold: true
              //padding: 10
              bottomPadding: 0

              onTextChanged: toValueMoney.text = result();
            }

            ComboBox{
                id: fromMoney
                model: modelMoney
                currentIndex: findElementIndex(modelMoney, "RUB")
                textRole: "money"
                x: parent.x+fromValueMoney.width
                //y: parent.y
                width: 100
                height: parent.height
                //padding: 10
                bottomPadding: 0
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                background: Rectangle {
                    color:"white"
                    border.width: parent && parent.activeFocus ? 2 : 1
                    border.color: parent && parent.activeFocus ? fromMoney.palette.highlight : fromMoney.palette.button
                }

                onCurrentIndexChanged: {
                    StaticVar.setFromMoney(currentIndex);
                    toValueMoney.text = result();
                }
            }

            Button{
                id:changeMoney
                text: " <=> ";
                width: 100
                height: parent.height
                x: fromMoney.x + fromMoney.width
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.bold: true
                //padding: 10
                bottomPadding: 0

                onClicked: {
                    fromMoney.currentIndex = [toMoney.currentIndex, toMoney.currentIndex = fromMoney.currentIndex][0];
                }
            }

            Text {
                id: toValueMoney
                text: "    ";
                width: 100
                height: parent.height
                x: changeMoney.x+changeMoney.width
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }

            ComboBox{
                id: toMoney
                currentIndex: findElementIndex(modelMoney, "CNY"/*"USD"*/)
                model: modelMoney
                textRole: "money"
                x: toValueMoney.x + toValueMoney.width
                //y: parent.y
                width:100
                //padding: 10
                bottomPadding: 0
                height: parent.height
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true

                background: Rectangle {
                    color:"white"
                    border.width: parent && parent.activeFocus ? 2 : 1
                    border.color: parent && parent.activeFocus ? fromMoney.palette.highlight : fromMoney.palette.button
                }

                onCurrentIndexChanged: {
                    StaticVar.setToMoney(currentIndex);
                    toValueMoney.text = result();
                }
             }
            }

        Button {
            x: parent.x
            height: parent.height
            width: parent.width
            bottomPadding: 0
            text: "Обновить данные"
            font.pointSize: 14
            font.family: "Courier"
            font.italic: true
            font.bold: true

            onClicked: {
                getData();
            }
        }

        Text {
            id: updateTime
            text: "";
            width: parent.width
            height: parent.height
            x: parent.x
            //y: parent.y
            font.pointSize: 14
            font.family: "Courier"
            font.italic: true
            font.bold: true
            padding: 10
            bottomPadding: 0
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
     }
      Component.onCompleted: {
          getData();
      }
  }
}
