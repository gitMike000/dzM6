import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Window {
    id: root

    function findElementIndex(myModel, myId) {
        for(var i = 0; i < myModel.count; i++) {
            var element = myModel.get(i);
            console.log(element.key);
            if(myId == element.key) {
                console.log(element.key);
                return element.cityEN;
            }
        }
        return "";
    }

    function roundNumber(number, digits) {
                var multiple = Math.pow(10, digits);
                var rndedNum = Math.round(number * multiple) / multiple;
                return rndedNum;
            }

    function getData() {        
        var city=findElementIndex(modelCity, selectCity.currentIndex);
        var xmlhttp = new XMLHttpRequest();
        var url = "https://api.openweathermap.org/data/2.5/weather?q="+city+"&APPID=64af70ad69320b1a2bd4d7f1b470ce0e"; // Идентификатор ресурса
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == XMLHttpRequest.DONE && xmlhttp.status == 200) {
                print(xmlhttp.responseText)
                parse(xmlhttp.responseText);
            }
        }
     xmlhttp.open("GET", url, true);
     xmlhttp.send();

    }

    function parse(response) {
        var jsonObj = JSON.parse(response);
        var jsonCoord = jsonObj.coord;
        var jsonWeather = jsonObj.weather[0];
        var jsonMain = jsonObj.main;
        var jsonWind = jsonObj.wind

        lon.text = jsonCoord.lon;
        lat.text = jsonCoord.lat;
        descrIcon.source = "qrc:/icon/icons/"+jsonWeather.icon+".png";
        descr.text = jsonWeather.description;
        temp.text = roundNumber((jsonMain.temp - 273),1) + " C";
        temp_min.text = roundNumber((jsonMain.temp_min - 273),1) + " C";
        temp_max.text = roundNumber((jsonMain.temp_max - 273),1) + " C";
        humidity.text = jsonMain.humidity +" %";
        speed.text = jsonWind.speed + " м/c";
        deg.text = jsonWind.deg + " º";
    }

    width: 550
    height: 350
    visible: true
    title: qsTr("Погода в любимом городе")

    Item{
        anchors.fill: parent
        ListModel {
            id: modelCity
            ListElement { key:0; cityEN:"Moscow";           cityRU:"Москва"  }
            ListElement { key:1; cityEN:"Saint Petersburg"; cityRU:"Санкт-Петербург"  }
            ListElement { key:2; cityEN:"Ekaterinburg";     cityRU:"Екатеринбург"  }
            ListElement { key:3; cityEN:"Murmansk";         cityRU:"Мурманск"  }
            ListElement { key:4; cityEN:"Novosibirsk";      cityRU:"Новосибирск"  }
            ListElement { key:5; cityEN:"Pskov";            cityRU:"Псков"  }
            ListElement { key:6; cityEN:"Cheboksary";       cityRU:"Чебоксары"  }
            ListElement { key:7; cityEN:"Irkutsk";          cityRU:"Иркутск"  }
            ListElement { key:8; cityEN:"Vladivostok";      cityRU:"Владивосток"  }
            ListElement { key:9; cityEN:"Petropavlovsk-Kamchatsky"; cityRU:"Петропавловск-Камчатский"  }
        }

      Column {
        id: col1
        x:10
        y:10
        width: 500
        height: 40

        ComboBox{
            id: selectCity
            model: modelCity
            currentIndex: 0
            textRole: "cityRU"
            x: parent.x
            //y: parent.y
            width: parent.width
            height: 40

            contentItem: Text {
                text: parent.displayText
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                verticalAlignment: Text.AlignVCenter;
                horizontalAlignment: Text.AlignHCenter;
                elide: Text.ElideRight
            }

            background: Rectangle {
                color:"white"
                border.width: parent && parent.activeFocus ? 2 : 1
                border.color: parent && parent.activeFocus ? selectCity.palette.highlight : selectCity.palette.button
            }

            onCurrentIndexChanged: {
                getData();
            }
        }

        Row {
            id: row1
            x: parent.x
            width: parent.width
            height: 55//parent.height

            Text {
                id: textLon
                text: "Долгота";
                width: 150
                height: parent.height
                x: parent.x
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }

            Text {
                id: textLat
                text: "Широта";
                width: 150
                height: parent.height
                x: textLon.x+textLon.width
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }

            Image {
                id: descrIcon
                source: ""
                width: 100
                height: 70
                x: textLat.x+textLat.width
            }
        }

        Row {
            id: row2
            x: parent.x
            width: parent.width
            height: parent.height

            Text {
                id: lon
                text: "";
                width: 120
                height: parent.height
                x: parent.x
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }

            Text {
                id: lat
                text: "";
                width: 120
                height: parent.height
                x: lon.x+lon.width
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }

            Text {
                id: descr
                text: "";
                width: 200
                height: parent.height
                x: lat.x+lat.width
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }
        }

        Row {
            id: row3
            x: parent.x
            width: parent.width
            height: parent.height
            Text {
                id: textTemp
                text: "Температура";
                width: 150
                height: parent.height
                x: parent.x
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }

            Text {
                id: textTemp_min
                text: "Мин.темпер.";
                width: 150
                height: parent.height
                x: textTemp.x+textTemp.width
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }

            Text {
                id: textTemp_max
                text: "Макс.темпер.";
                width: 150
                height: parent.height
                x: textTemp_min.x+textTemp_min.width
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }
        }

        Row {
            id: row4
            x: parent.x
            width: parent.width
            height: parent.height
            Text {
                id: temp
                text: "";
                width: 150
                height: parent.height
                x: parent.x
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }

            Text {
                id: temp_min
                text: "";
                width: 150
                height: parent.height
                x: temp.x+temp.width
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }

            Text {
                id: temp_max
                text: "";
                width: 150
                height: parent.height
                x: temp_min.x+temp_min.width
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }
        }

        Row {
            id: row5
            x: parent.x
            width: parent.width
            height: parent.height
            Text {
                id: textHumidity
                text: "Влажность";
                width: 150
                height: parent.height
                x: parent.x
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }

            Text {
                id: textSpeed
                text: "Скор.ветра";
                width: 150
                height: parent.height
                x: textHumidity.x+textHumidity.width
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }

            Text {
                id: textDeg
                text: "Направ.ветра";
                width: 150
                height: parent.height
                x: textSpeed.x+textSpeed.width
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }
        }

        Row {
            id: row6
            x: parent.x
            width: parent.width
            height: parent.height
            Text {
                id: humidity
                text: "";
                width: 150
                height: parent.height
                x: parent.x
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }

            Text {
                id: speed
                text: "";
                width: 150
                height: parent.height
                x: humidity.x+humidity.width
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }

            Text {
                id: deg
                text: "";
                width: 150
                height: parent.height
                x: speed.x+speed.width
                //y: parent.y
                font.pointSize: 14
                font.family: "Courier"
                font.italic: true
                font.bold: true
                padding: 10
                bottomPadding: 0
            }
        }

      Component.onCompleted: {
          getData();
      }
  }
}
}
