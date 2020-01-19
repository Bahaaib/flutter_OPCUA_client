package com.akwad.opcua_app;

import com.akwad.opcua_app.OpcUtils.ManagerOPC;
import com.akwad.opcua_app.OpcUtils.SessionElement;

import org.opcfoundation.ua.core.MonitoredItemNotification;

import java.util.ArrayList;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

public class NodeConnection implements Runnable {
    private String nodeIdString;
    private String type;
    private int sessionPosition;
    private int subscriptionPosition;
    private int monitoredItemPosition;

    public NodeConnection(String type, int sessionPosition, int subscriptionPosition, int monitoredItemPosition) {
        this.type = type;
        this.sessionPosition = sessionPosition;
        this.subscriptionPosition = subscriptionPosition;
        this.monitoredItemPosition = monitoredItemPosition;
    }

    @Override
    public void run() {
        final ScheduledThreadPoolExecutor executor_ =
                new ScheduledThreadPoolExecutor(1);
        executor_.scheduleWithFixedDelay(() -> {
            SessionElement sessionElement = ManagerOPC.getIstance().getSessions().get(sessionPosition);
            ArrayList<MonitoredItemNotification> monitoredItemNotificationList0 = new ArrayList<>(sessionElement
                    .getSubscriptions()
                    .get(subscriptionPosition)
                    .getMonitoreditems()
                    .get(monitoredItemPosition)
                    .getReadings());

            for(MonitoredItemNotification itemNotification : monitoredItemNotificationList0){
                System.out.println("VALUE = " + itemNotification.getValue().getValue() + "  NODE ID: " + type);
            }
        }, 0, 1000, TimeUnit.MILLISECONDS);
    }
}
