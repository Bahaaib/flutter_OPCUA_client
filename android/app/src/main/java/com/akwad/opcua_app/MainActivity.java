package com.akwad.opcua_app;

import android.annotation.SuppressLint;
import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.os.Message;

import com.akwad.opcua_app.OpcUtils.ConnectionThread.ThreadCreateMonitoredItem;
import com.akwad.opcua_app.OpcUtils.ConnectionThread.ThreadCreateSession;
import com.akwad.opcua_app.OpcUtils.ConnectionThread.ThreadCreateSubscription;
import com.akwad.opcua_app.OpcUtils.ManagerOPC;
import com.akwad.opcua_app.OpcUtils.SessionElement;
import com.akwad.opcua_app.OpcUtils.SubscriptionElement;

import org.opcfoundation.ua.application.Client;
import org.opcfoundation.ua.application.SessionChannel;
import org.opcfoundation.ua.builtintypes.DataValue;
import org.opcfoundation.ua.builtintypes.ExtensionObject;
import org.opcfoundation.ua.builtintypes.LocalizedText;
import org.opcfoundation.ua.builtintypes.NodeId;
import org.opcfoundation.ua.builtintypes.UnsignedByte;
import org.opcfoundation.ua.builtintypes.UnsignedInteger;
import org.opcfoundation.ua.common.ServiceResultException;
import org.opcfoundation.ua.core.ApplicationDescription;
import org.opcfoundation.ua.core.ApplicationType;
import org.opcfoundation.ua.core.Attributes;
import org.opcfoundation.ua.core.CreateMonitoredItemsRequest;
import org.opcfoundation.ua.core.CreateSubscriptionRequest;
import org.opcfoundation.ua.core.DataChangeFilter;
import org.opcfoundation.ua.core.DataChangeTrigger;
import org.opcfoundation.ua.core.DeadbandType;
import org.opcfoundation.ua.core.EndpointDescription;
import org.opcfoundation.ua.core.MessageSecurityMode;
import org.opcfoundation.ua.core.MonitoredItemCreateRequest;
import org.opcfoundation.ua.core.MonitoringMode;
import org.opcfoundation.ua.core.MonitoringParameters;
import org.opcfoundation.ua.core.ReadResponse;
import org.opcfoundation.ua.core.ReadValueId;
import org.opcfoundation.ua.core.TimestampsToReturn;
import org.opcfoundation.ua.transport.security.KeyPair;
import org.opcfoundation.ua.transport.security.SecurityPolicy;
import org.opcfoundation.ua.utils.CertificateUtils;
import org.opcfoundation.ua.utils.EndpointUtil;

import java.io.File;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
    private static Context mContext;
    private static final String CHANNEL = "flutter.native/helper";
    private String message;
    private ManagerOPC manager;
    private String url = "opc.tcp://192.168.1.2:49320";
    EndpointDescription endpoint;
    MonitoredItemCreateRequest[] monitoredItems;
    int value = 0;
    private ExecutorService executorService;

    ScheduledExecutorService executor = Executors.newSingleThreadScheduledExecutor();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        mContext = getApplicationContext();

        monitoredItems = new MonitoredItemCreateRequest[1];
        monitoredItems[0] = new MonitoredItemCreateRequest();
        executorService = Executors.newFixedThreadPool(4);


        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("launchClient")) {
                        new ConnectionTask().execute();
                    }

                });
    }

    private String helloFromNativeCode() {
        return "Hello from Native Android Code";
    }

    private String launchClient() {
        try {
            System.out.println("Launching");
            /////////////// CLIENT ///////////////
            // Create ApplicationDescription
            ApplicationDescription applicationDescription = new ApplicationDescription();
            applicationDescription.setApplicationName(new LocalizedText("AKWAD Client", Locale.ENGLISH));
            applicationDescription.setApplicationUri(getApplicationContext().getPackageName());
            applicationDescription.setProductUri("urn:lucazanrosso:AndroidClient");
            applicationDescription.setApplicationType(ApplicationType.Client);


            // Create Client Application Instance Certificate
            KeyPair myClientApplicationInstanceCertificate = CertificateUtils
                    .createApplicationInstanceCertificate("AKWAD Client", "Akwad", applicationDescription.getApplicationUri(), 10);

            System.out.println("createClientApplication...");

            // Create Client
            //Client myClient = Client.createClientApplication(myClientApplicationInstanceCertificate);
            //////////////////////////////////////

            File certFile = new File(getFilesDir(), "OPCCert.der");
            File privKeyFile = new File(getFilesDir(), "OPCCert.pem");

            manager = ManagerOPC.CreateManagerOPC(certFile, privKeyFile);

            Client mClient = manager.getClient();

            System.out.println("discoverEndpoints...");
            /////////// DISCOVER ENDPOINT ////////
            // Discover endpoints
            EndpointDescription[] endpoints = mClient.discoverEndpoints("opc.tcp://192.168.1.2:49320");
            System.out.println("STEP 1...");
            // Filter out all but opc.tcp protocol endpoints
            endpoints = EndpointUtil.selectByProtocol(endpoints, "opc.tcp");
            System.out.println("STEP 2...");
            // Filter out all but Signed & Encrypted endpoints
            endpoints = EndpointUtil.selectByMessageSecurityMode(endpoints, MessageSecurityMode.SignAndEncrypt);
            System.out.println("STEP 3...");
            // Filter out all but Basic256Sha256 cryption endpoints
            endpoints = EndpointUtil.selectBySecurityPolicy(endpoints, SecurityPolicy.BASIC256SHA256);
            System.out.println("STEP 4...");
            // Sort endpoints by security level. The lowest level at the beginning, the highest at the end of the array
            endpoints = EndpointUtil.sortBySecurityLevel(endpoints);

            // Choose one endpoint.
            EndpointDescription endpoint = endpoints[endpoints.length - 1];


            System.out.println("Security Level " + endpoint.getSecurityPolicyUri());
            System.out.println("Security Mode " + endpoint.getSecurityMode());
            //////////////////////////////////////

            System.out.println("Statuss: " + "STARTING...");

            /////////////// SESSION //////////////
            // Create the session from the chosen endpoint
            SessionChannel mySession = mClient.createSessionChannel(endpoint);
            System.out.println("Statuss: " + "CREATED SESSION CHANNEL");

            // Activate the session. Use mySession.activate() if you do not want to use user authentication
            mySession.activate();
            System.out.println("Statuss: " + "ACTIVATED");


            monitorNode("Simulation Examples.Functions.Ramp1", mySession, "Ramp1");
            monitorNode("Simulation Examples.Functions.Ramp2", mySession, "Ramp2");
            monitorNode("Simulation Examples.Functions.Ramp3", mySession, "Ramp3");
            monitorNode("Simulation Examples.Functions.Ramp4", mySession, "Ramp4");
            monitorNode("Simulation Examples.Functions.Ramp5", mySession, "Ramp5");
            monitorNode("Simulation Examples.Functions.Ramp6", mySession, "Ramp6");
            monitorNode("Simulation Examples.Functions.Ramp7", mySession, "Ramp7");
            monitorNode("Simulation Examples.Functions.Ramp8", mySession, "Ramp8");

            // Close the session
            //mySession.close();
            //mySession.closeAsync();
            //////////////////////////////////////

            return message;

        } catch (Exception e) {
            System.out.println("FAILED: " + e.toString());
            e.printStackTrace();
            return e.toString();
        }
    }

    void addNode(String targetNodeId){}

    void monitorNode(String targetNodeId, SessionChannel currentSession, String nodeLabel){
        // Read a variable
        NodeId nodeId = new NodeId(2, targetNodeId);
        ReadValueId readValueId = new ReadValueId(nodeId, Attributes.Value, null, null);

        executor.scheduleAtFixedRate(() -> {
            ReadResponse res = null;
            try {
                res = currentSession.Read(null, 500.0, TimestampsToReturn.Source, readValueId);
            } catch (ServiceResultException e) {
                e.printStackTrace();
            }
            DataValue[] dataValue = res.getResults();
            message = dataValue[0].getValue().toString();
            System.out.println(nodeLabel + " VALUE: " + message);
        }, 0, 1000, TimeUnit.MILLISECONDS);

    }

    class ConnectionTask extends AsyncTask<Void, Void, Void> {
        @Override
        protected Void doInBackground(Void... voids) {
            launchClient();
            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);
            //createSession();

//            createSessionForNode("Simulation Examples.Functions.Ramp1", "RAMP 1");
//            createSessionForNode("Simulation Examples.Functions.Ramp2", "RAMP 2");
//            createSessionForNode("Simulation Examples.Functions.Ramp3", "RAMP 3");
//            createSessionForNode("Simulation Examples.Functions.Ramp4", "RAMP 4");
//            createSessionForNode("Simulation Examples.Functions.Ramp5", "RAMP 5");
//            createSessionForNode("Simulation Examples.Functions.Ramp6", "RAMP 6");
//            createSessionForNode("Simulation Examples.Functions.Ramp7", "RAMP 7");
//            createSessionForNode("Simulation Examples.Functions.Ramp8", "RAMP 8");

        }
    }

    private String launchSubscription() {
        try {
            System.out.println("Launching");
            /////////////// CLIENT ///////////////
            // Create ApplicationDescription
            ApplicationDescription applicationDescription = new ApplicationDescription();
            applicationDescription.setApplicationName(new LocalizedText("AKWAD Client", Locale.ENGLISH));
            applicationDescription.setApplicationUri(getApplicationContext().getPackageName());
            applicationDescription.setProductUri("urn:lucazanrosso:AndroidClient");
            applicationDescription.setApplicationType(ApplicationType.Client);


            // Create Client Application Instance Certificate
            KeyPair myClientApplicationInstanceCertificate = CertificateUtils
                    .createApplicationInstanceCertificate("AKWAD Client", "Akwad", applicationDescription.getApplicationUri(), 10);

            System.out.println("createClientApplication...");

            // Create Client
            //Client myClient = Client.createClientApplication(myClientApplicationInstanceCertificate);
            //////////////////////////////////////

            File certFile = new File(getFilesDir(), "OPCCert.der");
            File privKeyFile = new File(getFilesDir(), "OPCCert.pem");

            manager = ManagerOPC.CreateManagerOPC(certFile, privKeyFile);

            Client mClient = manager.getClient();

            System.out.println("discoverEndpoints...");
            /////////// DISCOVER ENDPOINT ////////
            // Discover endpoints
            EndpointDescription[] endpoints = mClient.discoverEndpoints("opc.tcp://192.168.1.2:49320");
            System.out.println("STEP 1...");
            // Filter out all but opc.tcp protocol endpoints
            endpoints = EndpointUtil.selectByProtocol(endpoints, "opc.tcp");
            System.out.println("STEP 2...");
            // Filter out all but Signed & Encrypted endpoints
            endpoints = EndpointUtil.selectByMessageSecurityMode(endpoints, MessageSecurityMode.SignAndEncrypt);
            System.out.println("STEP 3...");
            // Filter out all but Basic256Sha256 cryption endpoints
            endpoints = EndpointUtil.selectBySecurityPolicy(endpoints, SecurityPolicy.BASIC256SHA256);
            System.out.println("STEP 4...");
            // Sort endpoints by security level. The lowest level at the beginning, the highest at the end of the array
            endpoints = EndpointUtil.sortBySecurityLevel(endpoints);

            // Choose one endpoint.
            endpoint = endpoints[endpoints.length - 1];

            return message;

        } catch (Exception e) {
            System.out.println("FAILED: " + e.toString());
            e.printStackTrace();
            return e.toString();
        }
    }

    void createSession() {
        ThreadCreateSession sessionThread = new ThreadCreateSession(manager, url, endpoint);
        @SuppressLint("HandlerLeak") Handler sessionHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if (msg.what == -1) {
                    System.out.println("Session couldn't be created");
                } else if (msg.what == -2) {
                    System.out.println("Session TIME OUT");

                } else {
                    System.out.println(msg.toString());
                    createSubscription((int) msg.obj);
                }
            }
        };
        sessionThread.start(sessionHandler);
    }

    void createSubscription(int sessionPosition) {
        ManagerOPC manager = ManagerOPC.getIstance();
        SessionElement sessionElement = manager.getSessions().get(sessionPosition);
        CreateSubscriptionRequest req =
                new CreateSubscriptionRequest(
                        null,
                        Double.valueOf(10d),
                        new UnsignedInteger(60),
                        new UnsignedInteger(20),
                        new UnsignedInteger(0),
                        true,
                        new UnsignedByte(0));

        ThreadCreateSubscription threadCreateSubscription = new ThreadCreateSubscription(sessionElement, req);

        @SuppressLint("HandlerLeak") Handler subscriptionHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                if (msg.what == -1) {
                    System.out.println("Subscription couldn't be created");
                } else if (msg.what == -2) {
                    System.out.println("TIME OUT");
                } else {
                    System.out.println(msg.toString());

                    new NodeTask(sessionPosition, (int)msg.obj, "Simulation Examples.Functions.Sine1", "SINE 1").execute();
                    new NodeTask(sessionPosition, (int)msg.obj, "Simulation Examples.Functions.Sine2", "SINE 2").execute();
                    new NodeTask(sessionPosition, (int)msg.obj, "Simulation Examples.Functions.Sine3", "SINE 3").execute();
                    new NodeTask(sessionPosition, (int)msg.obj, "Simulation Examples.Functions.Sine4", "SINE 4").execute();

                }
            }
        };

        threadCreateSubscription.start(subscriptionHandler);
    }

    void createMonitoredItems(int sessionPosition, int subscriptionPosition, String nodeIdString, String type) {
        DataChangeFilter filter = new DataChangeFilter();
        filter.setTrigger(DataChangeTrigger.StatusValue);
        filter.setDeadbandType(new UnsignedInteger(DeadbandType.Absolute.getValue()));
        filter.setDeadbandValue(Double.valueOf(100d));
        ExtensionObject fil = new ExtensionObject(filter);
        MonitoringParameters reqParams = new MonitoringParameters();
        reqParams.setClientHandle(new UnsignedInteger(value++));
        reqParams.setSamplingInterval(Double.valueOf(100d));
        reqParams.setQueueSize(new UnsignedInteger(4));
        reqParams.setDiscardOldest(true);
        reqParams.setFilter(fil);

        monitoredItems[0].setRequestedParameters(reqParams);
        monitoredItems[0].setMonitoringMode(MonitoringMode.Reporting);

        NodeId nodeId = new NodeId(2, nodeIdString);


        monitoredItems[0].setItemToMonitor(new ReadValueId(nodeId, Attributes.Value, null, null));

        createMonitoredItem(sessionPosition, subscriptionPosition, type);

    }

    void createMonitoredItem(int sessionPosition, int subscriptionPosition, String type) {
        SubscriptionElement subscriptionElement = manager.getSessions().get(sessionPosition).getSubscriptions().get(subscriptionPosition);

        System.out.println("SESSION ID: " + subscriptionElement.getSession().getSession().getName());
        System.out.println("SUBSCRIPTION ID: " + subscriptionElement.getSubscription().getSubscriptionId());

        final CreateMonitoredItemsRequest mi = new CreateMonitoredItemsRequest();
        mi.setSubscriptionId(subscriptionElement.getSubscription().getSubscriptionId());
        mi.setTimestampsToReturn(TimestampsToReturn.Both);
        mi.setItemsToCreate(monitoredItems);
        ThreadCreateMonitoredItem monitoredItemThread = new ThreadCreateMonitoredItem(subscriptionElement, mi);

        @SuppressLint("HandlerLeak") Handler monitoredItemHandler = new Handler(Looper.getMainLooper()) {
            @Override
            public void handleMessage(Message msg) {
                if (msg.what == -1) {
                    System.out.println(msg.toString());
                } else if (msg.what == -2) {
                    System.out.println("TIME OUT");
                } else if (msg.what == -3) {
                    System.out.println("MONITORING ERROR");
                } else {
                    System.out.println((int) msg.obj);
                    launchMonitoredItem(sessionPosition, subscriptionPosition, (int) msg.obj, type);
                }
            }
        };
        monitoredItemThread.start(monitoredItemHandler);
    }

    void launchMonitoredItem(int sessionPosition, int subscriptionPosition, int monitoredItemPosition, String type) {
        NodeConnection nodeConnection0 = new NodeConnection(type, sessionPosition, subscriptionPosition, monitoredItemPosition);

        executorService.execute(nodeConnection0);
    }

    class NodeTask extends AsyncTask<Void, Void, Void>{
        private int sessionPosition;
        private int subscriptionPosition;
        private String nodeId;
        private String type;

        public NodeTask(int sessionPosition, int subscriptionPosition, String nodeId, String type) {
            this.sessionPosition = sessionPosition;
            this.subscriptionPosition = subscriptionPosition;
            this.nodeId = nodeId;
            this.type = type;
        }

        @Override
        protected Void doInBackground(Void... voids) {
            createMonitoredItems(sessionPosition, subscriptionPosition, nodeId, type);
            return null;
        }
    }


}
