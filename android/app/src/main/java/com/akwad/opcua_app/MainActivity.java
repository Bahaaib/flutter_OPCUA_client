package com.akwad.opcua_app;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;

import com.akwad.opcua_app.OpcUtils.ManagerOPC;

import org.opcfoundation.ua.application.Client;
import org.opcfoundation.ua.application.SessionChannel;
import org.opcfoundation.ua.builtintypes.DataValue;
import org.opcfoundation.ua.builtintypes.LocalizedText;
import org.opcfoundation.ua.builtintypes.NodeId;
import org.opcfoundation.ua.common.ServiceResultException;
import org.opcfoundation.ua.core.ApplicationDescription;
import org.opcfoundation.ua.core.ApplicationType;
import org.opcfoundation.ua.core.Attributes;
import org.opcfoundation.ua.core.EndpointDescription;
import org.opcfoundation.ua.core.MessageSecurityMode;
import org.opcfoundation.ua.core.ReadResponse;
import org.opcfoundation.ua.core.ReadValueId;
import org.opcfoundation.ua.core.TimestampsToReturn;
import org.opcfoundation.ua.transport.security.KeyPair;
import org.opcfoundation.ua.transport.security.SecurityPolicy;
import org.opcfoundation.ua.utils.CertificateUtils;
import org.opcfoundation.ua.utils.EndpointUtil;

import java.io.File;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {
    private static Context mContext;
    private static final String LAUNCHER_CHANNEL = "flutter.native/launcher";
    private static final String RESULTS_CHANNEL = "flutter.native/results";

    private String message;
    private ManagerOPC manager;
    private SessionChannel mySession;
    final private ArrayList<NodeId> nodeIdsList = new ArrayList<>();

    ScheduledExecutorService executor = Executors.newSingleThreadScheduledExecutor();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);

        new MethodChannel(getFlutterView(), LAUNCHER_CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("launchClient")) {
                        new ConnectionTask().execute();
                    }

                });

        new MethodChannel(getFlutterView(), RESULTS_CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("getResults")) {
                        result.success(message);
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
            EndpointDescription[] endpoints = mClient.discoverEndpoints("opc.tcp://192.168.1.7:49320");
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
            mySession = mClient.createSessionChannel(endpoint);
            System.out.println("Statuss: " + "CREATED SESSION CHANNEL");

            // Activate the session. Use mySession.activate() if you do not want to use user authentication
            mySession.activate();
            System.out.println("Statuss: " + "ACTIVATED");

            //addNode("Simulation Examples.Functions.Ramp1");
            //addNode("Simulation Examples.Functions.Ramp2");
            //addNode("Simulation Examples.Functions.Ramp3");
            //addNode("Simulation Examples.Functions.Ramp4");
            //addNode("Simulation Examples.Functions.Ramp5");
            //addNode("Simulation Examples.Functions.Ramp6");
            //addNode("Simulation Examples.Functions.Ramp7");
            //addNode("Simulation Examples.Functions.Ramp8");
            addNode("Simulation Examples.Functions.Ramp1");
            startMonitoringForSession(mySession);


            // Close the session


            return message;

        } catch (Exception e) {
            System.out.println("FAILED: " + e.toString());
            e.printStackTrace();
            return e.toString();
        }
    }

    void addNode(String targetNodeId) {
        NodeId nodeId = new NodeId(2, targetNodeId);
        nodeIdsList.add(nodeId);
    }

    void removeNode(int index) {
        nodeIdsList.remove(index);
    }

    void closeSessionOnDemand(SessionChannel session){
        try {
            session.close();
            session.closeAsync();
        } catch (ServiceResultException e) {
            e.printStackTrace();
        }
    }

    void startMonitoringForSession(SessionChannel currentSession) {

        executor.scheduleAtFixedRate(() -> {
            for (NodeId nodeId : nodeIdsList) {

                ReadValueId readValueId = new ReadValueId(nodeId, Attributes.Value, null, null);

                ReadResponse res = null;
                try {
                    res = currentSession.Read(null, 500.0, TimestampsToReturn.Source, readValueId);
                } catch (ServiceResultException e) {
                    e.printStackTrace();
                }
                DataValue[] dataValue = res.getResults();
                message = dataValue[0].getValue().toString();
                System.out.println(nodeId.getValue().toString().substring(30)+ " VALUE: " + message);
            }
        }, 0, 1000, TimeUnit.MILLISECONDS);

    }

    void displaySnapshotTime(){
        Date date = new Date();
        long currentDate = date.getTime();
        Timestamp timestamp = new Timestamp(currentDate);

        System.out.println("CAPTURED AT:"+  timestamp);
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

}
