import QtQuick
import QtQuick.Window
import QtQuick.Layouts
import QtQuick.Controls as Controls

Rectangle {
    id: root

    width: Screen.width
    height: Screen.height
    color: "#2e3440"

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: "#2e3440"
        }
        GradientStop {
            position: 0.55
            color: "#353c4a"
        }
        GradientStop {
            position: 1.0
            color: "#242a35"
        }
    }

    // Decorative background circles
    Rectangle {
        width: 520
        height: 520
        radius: 260
        x: root.width * 0.68
        y: -180
        color: "#3b4252"
        opacity: 0.35
    }

    Rectangle {
        width: 360
        height: 360
        radius: 180
        x: -130
        y: root.height * 0.70
        color: "#88c0d0"
        opacity: 0.12
    }

    function submitLogin() {
        const username = user.currentText

        if (username.length > 0) {
            message.text = ""
            sddm.login(username, password.text, session.currentIndex)
        }
    }

    Item {
        anchors.fill: parent
        anchors.margins: 48

        ColumnLayout {
            anchors.centerIn: parent
            width: Math.min(380, parent.width)
            spacing: 0

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                width: 54
                height: 4
                radius: 2
                color: "#88c0d0"
            }

            Text {
                id: dateText

                Layout.topMargin: 22
                Layout.alignment: Qt.AlignHCenter

                text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
                color: "#b8c2ce"
                font.pixelSize: 14
                font.letterSpacing: 1
            }

            Text {
                id: clockText

                Layout.topMargin: 4
                Layout.alignment: Qt.AlignHCenter

                text: Qt.formatDateTime(new Date(), "hh:mm")
                color: "#eceff4"
                font.pixelSize: 58
                font.weight: Font.Light
            }

            Timer {
                interval: 1000
                running: true
                repeat: true

                onTriggered: {
                    const now = new Date()
                    clockText.text = Qt.formatDateTime(now, "hh:mm")
                    dateText.text = Qt.formatDateTime(now, "dddd, MMMM d")
                }
            }

            Text {
                Layout.topMargin: 34
                Layout.alignment: Qt.AlignHCenter

                text: "Welcome back"
                color: "#eceff4"
                font.pixelSize: 23
                font.weight: Font.Medium
            }

            Text {
                Layout.topMargin: 7
                Layout.bottomMargin: 22
                Layout.alignment: Qt.AlignHCenter

                text: "Sign in to continue"
                color: "#8995a7"
                font.pixelSize: 13
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: form.implicitHeight + 36

                radius: 18
                color: "#eb2e3440"

                border.width: 1
                border.color: "#4c566a"

                ColumnLayout {
                    id: form

                    anchors.fill: parent
                    anchors.margins: 18
                    spacing: 12

                    // User
                    Text {
                        text: "USER"
                        color: "#8995a7"
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 1
                    }

                    Controls.ComboBox {
                        id: user

                        Layout.fillWidth: true
                        implicitHeight: 44

                        model: userModel
                        textRole: "name"
                        currentIndex: userModel.lastIndex

                        font.pixelSize: 13

                        contentItem: Text {
                            leftPadding: 12
                            rightPadding: 30
                            text: user.displayText
                            color: "#eceff4"
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            font: user.font
                        }

                        indicator: Text {
                            x: parent.width - width - 14
                            y: (parent.height - height) / 2
                            text: "⌄"
                            color: "#88c0d0"
                            font.pixelSize: 20
                        }

                        background: Rectangle {
                            radius: 10
                            color: "#3b4252"
                            border.color: user.activeFocus
                                ? "#88c0d0"
                                : "#4c566a"
                        }

                        delegate: Controls.ItemDelegate {
                            width: user.width - user.popup.padding * 2
                            implicitHeight: 36
                            padding: 8
                            text: model.name

                            contentItem: Text {
                                text: model.name
                                color: "#eceff4"
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 13
                            }

                            background: Rectangle {
                                color: highlighted
                                    ? "#434c5e"
                                    : "#3b4252"
                            }
                        }

                        popup.padding: 4
                        popup.implicitHeight: contentItem.implicitHeight + padding * 2
                        popup.contentItem: ListView {
                            clip: true
                            implicitHeight: contentHeight
                            model: user.delegateModel
                            currentIndex: user.highlightedIndex
                        }
                        popup.background: Rectangle {
                            color: "#3b4252"
                            border.width: 1
                            border.color: "#4c566a"
                            radius: 8
                        }
                    }

                    // Password
                    Text {
                        Layout.topMargin: 2
                        text: "PASSWORD"
                        color: "#8995a7"
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 1
                    }

                    Controls.TextField {
                        id: password

                        Layout.fillWidth: true
                        implicitHeight: 44

                        placeholderText: "Enter your password"
                        placeholderTextColor: "#8995a7"
                        leftPadding: 12
                        rightPadding: 12
                        echoMode: TextInput.Password
                        font.pixelSize: 13

                        color: "#eceff4"
                        selectionColor: "#88c0d0"
                        selectedTextColor: "#2e3440"

                        background: Rectangle {
                            color: "#3b4252"
                            radius: 10
                            border.color: password.activeFocus
                                ? "#88c0d0"
                                : "#4c566a"
                        }

                        onAccepted: root.submitLogin()
                    }

                    // Desktop session
                    Text {
                        Layout.topMargin: 2
                        text: "DESKTOP SESSION"
                        color: "#8995a7"
                        font.pixelSize: 10
                        font.bold: true
                        font.letterSpacing: 1
                    }

                    Controls.ComboBox {
                        id: session

                        Layout.fillWidth: true
                        implicitHeight: 40

                        model: sessionModel
                        textRole: "name"
                        currentIndex: sessionModel.lastIndex

                        font.pixelSize: 12

                        contentItem: Text {
                            leftPadding: 12
                            rightPadding: 30
                            text: session.displayText
                            color: "#eceff4"
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            font: session.font
                        }

                        indicator: Text {
                            x: parent.width - width - 14
                            y: (parent.height - height) / 2
                            text: "⌄"
                            color: "#88c0d0"
                            font.pixelSize: 20
                        }

                        background: Rectangle {
                            radius: 10
                            color: "#3b4252"
                            border.color: session.activeFocus
                                ? "#88c0d0"
                                : "#4c566a"
                        }

                        delegate: Controls.ItemDelegate {
                            width: session.width - session.popup.padding * 2
                            implicitHeight: 36
                            padding: 8
                            text: model.name

                            contentItem: Text {
                                text: model.name
                                color: "#eceff4"
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 12
                            }

                            background: Rectangle {
                                color: highlighted
                                    ? "#434c5e"
                                    : "#3b4252"
                            }
                        }

                        popup.padding: 4
                        popup.implicitHeight: contentItem.implicitHeight + padding * 2
                        popup.contentItem: ListView {
                            clip: true
                            implicitHeight: contentHeight
                            model: session.delegateModel
                            currentIndex: session.highlightedIndex
                        }
                        popup.background: Rectangle {
                            color: "#3b4252"
                            border.width: 1
                            border.color: "#4c566a"
                            radius: 8
                        }
                    }

                    // Sign in button
                    Controls.Button {
                        id: loginButton

                        Layout.fillWidth: true
                        Layout.topMargin: 4
                        implicitHeight: 44

                        text: "Sign in"
                        font.pixelSize: 14
                        font.weight: Font.DemiBold

                        onClicked: root.submitLogin()

                        contentItem: Text {
                            text: loginButton.text
                            color: "#2e3440"
                            font: loginButton.font
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle {
                            radius: 10
                            color: loginButton.hovered
                                ? "#a3d0dc"
                                : "#88c0d0"
                        }
                    }

                    // Error message
                    Text {
                        id: message

                        Layout.fillWidth: true
                        visible: text.length > 0

                        text: ""
                        color: "#bf616a"
                        horizontalAlignment: Text.AlignHCenter

                        wrapMode: Text.WordWrap
                        font.pixelSize: 12
                    }
                }
            }
        }

        // Footer
        Text {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            text: "NORD  ·  " + sddm.hostName
            color: "#748195"

            font.pixelSize: 10
            font.letterSpacing: 2
        }
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            message.text = "Login failed — check your password and try again"
            password.clear()
            password.forceActiveFocus()
        }

        function onLoginSucceeded() {
            message.text = ""
        }
    }

    Component.onCompleted: {
        password.forceActiveFocus()
    }
}
