pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

Scope {
    id: root
    property var unreadIds: []
    property var popupIds: []
    readonly property bool unread: unreadIds.length > 0
    readonly property var notifications: server.trackedNotifications.values
    function markRead() {
        unreadIds = [];
        popupIds = [];
        for (const notification of notifications.slice()) if (notification.transient) notification.expire();
    }
    function remove(id) {
        unreadIds = unreadIds.filter(value => value !== id);
        popupIds = popupIds.filter(value => value !== id);
    }
    function clear() { for (const notification of notifications.slice()) notification.dismiss(); }
    NotificationServer {
        id: server
        actionsSupported: true
        persistenceSupported: true
        onNotification: notification => {
            notification.tracked = true;
            if (!notification.lastGeneration) {
                root.unreadIds = root.unreadIds.filter(id => id !== notification.id).concat([notification.id]);
                root.popupIds = root.popupIds.filter(id => id !== notification.id).concat([notification.id]);
            }
        }
    }
    Instantiator {
        model: server.trackedNotifications
        delegate: QtObject {
            id: tracked
            required property var modelData
            property Connections connection: Connections {
                target: tracked.modelData
                function onClosed() { root.remove(tracked.modelData.id); }
            }
            property Timer timeout: Timer {
                interval: tracked.modelData.expireTimeout > 0 ? tracked.modelData.expireTimeout * 1000 : 6000
                running: root.popupIds.includes(tracked.modelData.id) && tracked.modelData.expireTimeout !== 0 && tracked.modelData.urgency !== NotificationUrgency.Critical
                onTriggered: {
                    const notification = tracked.modelData;
                    root.popupIds = root.popupIds.filter(id => id !== notification.id);
                    if (notification.transient) notification.expire();
                }
            }
        }
    }
}
