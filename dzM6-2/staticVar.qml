pragma Singleton
import QtQuick 2.15

QtObject {
    property int indToMoney: 10
    property int indFromMoney: 10

    function setToMoney(a) {
        if (a != -1) indToMoney = a;
    }

    function setFromMoney(a) {
        if (a != -1) indFromMoney = a;
    }
}
