import "../core"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    visible: false
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    WlrLayershell.namespace: "nord-launcher"
    // Keep the Wayland surface stable while typing. Only its masked panel changes size.
    implicitWidth: Math.min(410, screen ? screen.width - 38 : 410)
    implicitHeight: maximumResultsHeight + 231
    mask: Region { item: surface }
    readonly property real maximumResultsHeight: screen ? Math.max(0, Math.min(340, screen.height * 0.45, screen.height - 255)) : 340
    readonly property real resultsHeight: Math.min(Math.max(0, matches.length * 43 - 3), maximumResultsHeight)

    readonly property string query: search.text.trim()
    readonly property bool expanded: query.length > 0
    readonly property bool nixSearch: /^!nix(?:\s|$)/i.test(query)
    readonly property string webQuery: nixSearch ? query.replace(/^!nix\s*/i, "") : query
    readonly property var matches: nixSearch ? [] : DesktopEntries.applications.values.filter(app =>
        (app.name + " " + app.genericName + " " + app.keywords.join(" ")).toLowerCase().includes(query.toLowerCase())
    ).sort((a, b) => a.name.localeCompare(b.name))
    property int selected: -1
    readonly property int optionCount: matches.length + (expanded ? 1 : 0)

    onMatchesChanged: {
        syncResults();
        selected = matches.length ? 0 : -1;
        results.contentY = 0;
    }

    // Reconcile by desktop ID instead of resetting the model and recreating every row.
    ListModel { id: appModel; dynamicRoles: true }

    function syncResults() {
        for (let i = 0; i < matches.length; ++i) {
            const app = matches[i];
            if (i < appModel.count && appModel.get(i).desktopEntry.id === app.id) continue;
            let existing = -1;
            for (let j = i + 1; j < appModel.count; ++j) {
                if (appModel.get(j).desktopEntry.id === app.id) { existing = j; break; }
            }
            if (existing >= 0) appModel.move(existing, i, 1);
            else appModel.insert(i, { desktopEntry: app });
        }
        if (appModel.count > matches.length) appModel.remove(matches.length, appModel.count - matches.length);
    }

    function iconIndex(id) {
        let hash = 0;
        for (let i = 0; i < id.length; ++i) hash = (hash * 31 + id.charCodeAt(i)) | 0;
        return (hash >>> 0) % Nord.iconTop.length;
    }
    onVisibleChanged: {
        search.text = "";
        if (visible) search.forceActiveFocus();
    }

    function move(direction) {
        if (!optionCount) return;
        selected = selected < 0 ? (direction > 0 ? 0 : optionCount - 1) : (selected + direction + optionCount) % optionCount;
        if (selected < matches.length) results.positionViewAtIndex(selected, ListView.Contain);
    }
    function open(index) {
        if (index >= 0 && index < matches.length) {
            const app = matches[index];
            // Quickshell 0.3 does not wrap terminal desktop entries itself.
            if (app.runInTerminal)
                Quickshell.execDetached({ command: ["foot", "-e"].concat(app.command), workingDirectory: app.workingDirectory });
            else app.execute();
        } else if (expanded) {
            const url = nixSearch
                ? "https://search.nixos.org/packages" + (webQuery ? "?query=" + encodeURIComponent(webQuery) : "")
                : "https://www.google.com/search?q=" + encodeURIComponent(webQuery);
            Qt.openUrlExternally(url);
        } else return;
        visible = false;
    }

    Rectangle {
        id: surface
        anchors.centerIn: parent
        width: Math.min(root.expanded ? 410 : 380, parent.width)
        // Derive height from the result count, not ListView's asynchronously estimated contentHeight.
        height: root.expanded ? 207 + root.resultsHeight : 44
        Behavior on width { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
        Behavior on height { NumberAnimation { duration: 160; easing.type: Easing.OutCubic } }
        clip: true
        radius: expanded ? 20 : 22
        color: expanded ? Nord.launcherBg : Nord.pill
        border.width: root.expanded ? 1 : 0
        border.color: Nord.launcherBorder

        ColumnLayout {
            id: content
            anchors { left: parent.left; right: parent.right; top: parent.top; margins: root.expanded ? 16 : 13 }
            anchors.topMargin: root.expanded ? 16 : 0
            spacing: 0

            RowLayout {
                visible: root.expanded
                Layout.fillWidth: true
                Layout.bottomMargin: 11
                Text { text: "APPLICATIONS"; color: Nord.secondary; font { pixelSize: 10; weight: Font.Bold; letterSpacing: 1.2 } }
                Item { Layout.fillWidth: true }
                Text { text: "Type to search"; color: Nord.hint; font.pixelSize: 10 }
            }
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: root.expanded ? 40 : 44
                radius: root.expanded ? 12 : 22
                color: root.expanded ? Nord.pill : "transparent"
                border.width: root.expanded ? 1 : 0
                border.color: Nord.launcherBorder
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: root.expanded ? 11 : 0
                    anchors.rightMargin: root.expanded ? 11 : 0
                    spacing: 9
                    Text { text: "⌕"; color: Nord.accent; font.pixelSize: 18; Layout.preferredWidth: 22; horizontalAlignment: Text.AlignHCenter }
                    TextInput {
                        id: search
                        Layout.fillWidth: true
                        color: Nord.fg
                        font.pixelSize: 12
                        clip: true
                        selectByMouse: true
                        focus: true
                        Text { visible: !search.text; text: "Search apps or the web…"; color: Nord.placeholder; font: search.font }
                        Keys.onDownPressed: root.move(1)
                        Keys.onUpPressed: root.move(-1)
                        Keys.onReturnPressed: { if (root.expanded) root.open(root.selected < 0 ? root.matches.length : root.selected); }
                        Keys.onEscapePressed: { if (text.length) text = ""; else root.visible = false; }
                    }
                    Text { visible: root.expanded; text: "Esc"; color: Nord.secondary; font.pixelSize: 10 }
                }
            }
            Text {
                visible: root.expanded
                text: "RESULTS"
                color: Nord.hint
                font { pixelSize: 10; weight: Font.DemiBold; letterSpacing: 1 }
                Layout.topMargin: 14
                Layout.bottomMargin: 6
                Layout.leftMargin: 4
            }
            ListView {
                id: results
                visible: root.expanded
                Layout.fillWidth: true
                Layout.preferredHeight: root.resultsHeight
                clip: true
                spacing: 3
                model: appModel
                delegate: Rectangle {
                    id: appRow
                    required property var desktopEntry
                    readonly property int paletteIndex: root.iconIndex(desktopEntry.id)
                    required property int index
                    readonly property bool highlighted: root.selected === index || hover.containsMouse
                    width: results.width
                    height: 40
                    radius: 10
                    color: highlighted ? Nord.accent : "transparent"
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 10
                        Rectangle {
                            Layout.preferredWidth: 27
                            Layout.preferredHeight: 27
                            radius: 8
                            gradient: Gradient {
                                GradientStop { position: 0; color: Nord.iconTop[appRow.paletteIndex] }
                                GradientStop { position: 1; color: Nord.iconBottom[appRow.paletteIndex] }
                            }
                            Image { anchors.fill: parent; anchors.margins: 3; source: appRow.desktopEntry.icon ? Quickshell.iconPath(appRow.desktopEntry.icon, true) : ""; fillMode: Image.PreserveAspectFit }
                            Text { anchors.centerIn: parent; visible: !appRow.desktopEntry.icon; text: appRow.desktopEntry.name.charAt(0); color: Nord.accentFg; font.pixelSize: 13 }
                        }
                        Text { Layout.fillWidth: true; text: appRow.desktopEntry.name; elide: Text.ElideRight; color: appRow.highlighted ? Nord.accentFg : Nord.text; font { pixelSize: 12; weight: Font.Medium } }
                        Text { Layout.maximumWidth: 100; text: appRow.desktopEntry.genericName || appRow.desktopEntry.categories[0] || "Application"; elide: Text.ElideRight; color: appRow.highlighted ? Nord.selectedMetadata : Nord.metadata; font.pixelSize: 10 }
                        Text { visible: root.selected === appRow.index; text: "↵"; color: Nord.accentFg; font.pixelSize: 12 }
                    }
                    MouseArea { id: hover; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.open(appRow.index) }
                }
            }
            Rectangle {
                id: web
                visible: root.expanded
                Layout.fillWidth: true
                Layout.topMargin: 5
                implicitHeight: 43
                radius: 10
                readonly property bool highlighted: root.selected === root.matches.length || webHover.containsMouse
                color: highlighted ? Nord.accent : Nord.pill
                border.width: 1
                border.color: highlighted ? Nord.accent : Nord.launcherBorder
                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 8
                    spacing: 10
                    Rectangle { width: 27; height: 27; radius: 8; color: Nord.pillHover; Text { anchors.centerIn: parent; text: "↗"; color: Nord.accent } }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 0
                        Text { Layout.fillWidth: true; elide: Text.ElideRight; text: root.nixSearch ? (root.webQuery ? "Search Nix packages for “" + root.webQuery + "”" : "Search Nix packages") : "Search the web for “" + root.webQuery + "”"; color: web.highlighted ? Nord.accentFg : Nord.text; font { pixelSize: 11; weight: Font.DemiBold } }
                        Text { text: root.nixSearch ? "NixOS package search" : "Web search"; color: web.highlighted ? Nord.selectedMetadata : Nord.hint; font.pixelSize: 10 }
                    }
                }
                MouseArea { id: webHover; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: root.open(root.matches.length) }
            }
            Rectangle { visible: root.expanded; Layout.fillWidth: true; Layout.topMargin: 10; height: 1; color: Nord.sep }
            RowLayout {
                visible: root.expanded
                Layout.fillWidth: true
                Layout.topMargin: 8
                Text { text: "↑ ↓ move"; color: Nord.hint; font.pixelSize: 10 }
                Item { Layout.fillWidth: true }
                Text { text: "Enter open · Esc clear"; color: Nord.secondary; font.pixelSize: 10 }
                Item { Layout.fillWidth: true }
                Text { text: "!nix packages"; color: Nord.hint; font.pixelSize: 10 }
            }
        }
    }
}
