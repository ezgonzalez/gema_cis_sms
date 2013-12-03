package ar.com.gemasms.modem;

//
///*
// * @(#)SMS.java
// *
// * Copyright (C) 2008 Franck Andriano
// * 
// * This program is free software; you can redistribute it and/or
// * modify it under the terms of the GNU General Public License
// * as published by the Free Software Foundation; either version 2
// * of the License, or (at your option) any later version.
// * 
// * This program is distributed in the hope that it will be useful,
// * but WITHOUT ANY WARRANTY; without even the implied warranty of
// * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// * GNU General Public License for more details.
// * 
// * You should have received a copy of the GNU General Public License
// * along with this program; if not, write to the Free Software
// * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
// * 
// * See GPL license : http://www.gnu.org/licenses/gpl.html
// * 
// */
//
//import java.io.IOException;
//import java.io.InputStream;
//import java.io.OutputStream;
//import java.util.ArrayList;
//import java.util.Enumeration;
//import java.util.List;
//import java.util.StringTokenizer;
//import java.util.TooManyListenersException;
//
//import models.mensaje.MensajeEntrante;
//import models.mensaje.MensajeSaliente;
//import play.Logger;
//import play.Logger.ALogger;
//import ar.com.gemasms.modem.serial.SerialParameters;
//
////import org.apache.log4j.Logger;
//
///**
// * Classe permettant de communiquer avec un Port/Serie ou RS-232 hardware
// * Accepte les commandes 3GPP 27.007 et les recommandations 27.005 GSM pour une
// * carte SIM...
// * 
// * La communication en elle m�me peut se faire par cable Port Serie, IR ou
// * Bluetooth
// * 
// * T�l�charger Java Communications 3.0 API :
// * http://java.sun.com/products/javacomm/
// * 
// * - Installer le jar javax.comm dans le classpath de votre application
// * (comm.jar) et le fichier de configuration javax.comm.properties aussi
// * 
// * - Installer la dll pour Win32 seulement 'win32com.dll' dans le r�pertoire
// * 'bin' de votre JRE
// * 
// * Le "Pairing" de votre Adapteur Bluethooth et de votre GSM est indispensable
// * avant toute communication (via le service Virtual Serial Device Bluetooth)
// * 
// * @author Franck Andriano 2008 nexus6@altern.org
// * @version 1.0
// */
public class ModemSMS
// implements SerialPortEventListener,
// CommPortOwnershipListener
{
}

//
// private static ALogger logger = Logger.of(ModemSMS.class);
//
// private static String MENSAJES_RECIBIDOS_NO_LEIDOS = "+CMGR: \"REC READ\"";
//
// private static String MENSAJES_RECIBIDOS_LEIDOS = "+CMGR: \"REC UNREAD\"";
//
// /*
// * Constance status
// */
// public static final int SC_OK = 0;
// public static final int SC_ERROR = 1;
// public static final int SC_PDU_PARSE_ERROR = 2;
//
// /*
// * Flux I/O
// */
// private OutputStream outStream;
// private InputStream inStream;
//
// /*
// * Read incoming SMS from SIM
// */
// public MensajeEntrante mensajeEntrante = null;
//
// private boolean recibirMensaje = false;
//
// /*
// * Config Serial Port
// */
// private SerialParameters parameters;
//
// /*
// * Communication scan port
// */
// private CommPortIdentifier portId;
//
// /*
// * Communication in serial port
// */
// private SerialPort sPort;
//
// /*
// * Status comm port
// */
// public TipoRespuestaModem estadoDelPuerto = TipoRespuestaModem.OK;
// private static Boolean portStatusLock = new Boolean(true);
// private boolean POLLING_FLAG;
// private String portStatusMsg = "";
//
// /*
// * Buffer serial incoming event
// */
// private byte[] readBuffer = new byte[20000];
// private int bufferOffset = 0; // serialEvent
//
// /*
// * LF CR
// */
// private static final String lfcr = "\r\n";
//
// /*
// * Default index memory is 1
// */
// private int indexCurrentMemory = 1;
//
// /*
// * Default memory is "SM"
// */
// private String currentMemory = "\"SM\"";
//
// /**
// * Constructor!
// *
// * @param parameters
// */
// public ModemSMS(SerialParameters parameters) {
// this.parameters = parameters;
// }
//
// /**
// * Initialize driver to be able to connect to serial port incase application
// * is running from Windows as u might expect no driver initialization is
// * required on linux ensure you initialize only once on Windows so as to
// * avoid multiple port enumeration
// *
// * @return String "suncessful" or "failure"
// */
// public String initializeWinDrivers() {
// String drivername = "com.sun.comm.Win32Driver";
// try {
// CommDriver driver = (CommDriver) Class.forName(drivername)
// .newInstance();
// driver.initialize();
// return "successful";
// } catch (Throwable th) {
// // Discard it
// return "failure";
// }
// }
//
// /**
// * Return type of serial port (depend type of driver!)
// * Driver=com.sun.comm.Win32Driver (window) Driver=gnu.io.RXTXCommDriver
// * (all platform)
// *
// * @param portType
// * @return String with driver type
// */
// static String getPortTypeName(int portType) {
// // we use on window...
// switch (portType) {
// case CommPortIdentifier.PORT_PARALLEL:
// return "Parallel";
// case CommPortIdentifier.PORT_SERIAL:
// return "Serial";
// default:
// return "unknown type";
// }
// }
//
// /**
// * Open serial connection with COM port
// *
// * @param _port
// * @throws IOException
// */
// public void openConnection(String _port) throws IOException {
// openConnection(_port, null);
// }
//
// /**
// * Open serial connection with COM port
// *
// * @param _port
// * @param _pinNumber
// * @throws IOException
// */
// public void openConnection(String _port, String _pinNumber)
// throws IOException {
// String port = _port;
// if (_port == null)
// port = parameters.getPortName();
//
// // Obtain a CommPortIdentifier object for the port you want to open.
// try {
// portId = CommPortIdentifier.getPortIdentifier(port);
// } catch (NoSuchPortException e) {
// e.printStackTrace();
// throw new IOException(e.getMessage());
// }
//
// // Open the port represented by the CommPortIdentifier object. Give
// // the open call a relatively long timeout of 30 seconds to allow
// // a different application to reliquish the port if the user
// // wants to.
// try {
// sPort = (SerialPort) portId.open("MobileAccess", 5000);
// } catch (PortInUseException e) {
// throw new IOException(e.getMessage());
// }
//
// // Set the parameters of the connection. If they won't set, close the
// // port before throwing an exception.
// try {
// setConnectionParameters();
// } catch (IOException e) {
// sPort.close();
// throw e;
// }
//
// // Open the input and output streams for the connection. If they won't
// // open, close the port before throwing an exception.
// try {
// outStream = sPort.getOutputStream();
// inStream = sPort.getInputStream();
// } catch (IOException e) {
// sPort.close();
// throw new IOException("Error opening i/o streams");
// }
// // Add this object as an event listener for the serial port.
// try {
// sPort.addEventListener(this);
// } catch (TooManyListenersException e) {
// sPort.close();
// throw new IOException("too many listeners added");
// }
//
// // Set notifyOnDataAvailable to true to allow event driven input.
// sPort.notifyOnDataAvailable(true);
//
// // Add ownership listener to allow ownership event handling.
// portId.addPortOwnershipListener(this);
//
// // init modem connection with pin number
// initializeModem(_pinNumber);
// }
//
// /**
// * Initialize modem with PIN number
// *
// * @param pinNumber
// */
// private void initializeModem(String pinNumber) {
// atCmd("ATE0", 0, 1000); // turn off command echo
// atCmd("AT+CMEE=2", 0, 500); // verbose all messages
// atCmd("AT+CMGF=1", 0, 500); // set Pdu mode (default binary)
// // atCmd("AT+CNMI=0,0,0,0", 0, 500);// disable indications -direct to
// // TE?
//
// if (pinNumber != null) {
// // enter pin number
// atCmd("AT+CPIN=\"" + pinNumber + "\"", 0, 1000);
// if (estadoDelPuerto.esConError()) {
// logger.error("The pin number " + pinNumber
// + " is INCORRECT. Please try again.");
// // close session!
// this.close();
// }
// }
// }
//
// /**
// * List open serial port
// *
// * @return Array String
// */
// public String[] listPorts() {
// Enumeration ports = CommPortIdentifier.getPortIdentifiers();
// ArrayList portList = new ArrayList();
// String portArray[] = null;
// while (ports.hasMoreElements()) {
// CommPortIdentifier port = (CommPortIdentifier) ports.nextElement();
// if (port.getPortType() == CommPortIdentifier.PORT_SERIAL) {
// portList.add(port.getName());
// }
// portArray = (String[]) portList.toArray(new String[0]);
// }
// return portArray;
// }
//
// /**
// * Handles ownership events. If a PORT_OWNERSHIP_REQUESTED event is received
// * a dialog box is created asking the user if they are willing to give up
// * the port. No action is taken on other types of ownership events.
// */
// public void ownershipChange(int type) {
// if (type == CommPortOwnershipListener.PORT_OWNERSHIP_REQUESTED) {
// logger.debug("PORT_OWNERSHIP_REQUESTED received : Your port has been requested by an other application...");
//
// this.close();
// } else if (type == CommPortOwnershipListener.PORT_OWNED) {
// logger.debug("PORT_OWNED received!");
// } else if (type == CommPortOwnershipListener.PORT_UNOWNED) {
// logger.debug("PORT_UNOWNED received!");
// }
// }
//
// /**
// * Sets the connection parameters to the setting in the parameters object.
// * If set fails return the parameters object to origional settings and throw
// * exception.
// */
// private void setConnectionParameters() throws IOException {
// // Save state of parameters before trying a set.
// int oldBaudRate = sPort.getBaudRate();
// int oldDatabits = sPort.getDataBits();
// int oldStopbits = sPort.getStopBits();
// int oldParity = sPort.getParity();
// int oldFlowControl = sPort.getFlowControlMode();
//
// // Set connection parameters, if set fails return parameters object
// // to original state.
// try {
// sPort.setSerialPortParams(parameters.getBaudRate(),
// parameters.getDatabits(), parameters.getStopbits(),
// parameters.getParity());
// } catch (UnsupportedCommOperationException e) {
// parameters.setBaudRate(oldBaudRate);
// parameters.setDatabits(oldDatabits);
// parameters.setStopbits(oldStopbits);
// parameters.setParity(oldParity);
// parameters.setFlowControlIn(oldFlowControl);
// parameters.setFlowControlOut(oldFlowControl);
// throw new IOException("Unsupported parameter");
// }
// // Set flow control.
// try {
// sPort.setFlowControlMode(parameters.getFlowControlIn()
// | parameters.getFlowControlOut());
// sPort.enableReceiveThreshold(1);
// sPort.enableReceiveTimeout(2000); // timeout 2s ?!
// } catch (UnsupportedCommOperationException e) {
// throw new IOException("Unsupported flow control");
// }
// }
//
// // To be used to send AT command via the IR/serial link to the mobile
// // device (for standard AT commands use mode=0)
// private synchronized TipoRespuestaModem atCmd(String cmd, int mode,
// int timeout) {
//
// logger.trace(cmd);
//
// synchronized (portStatusLock) {
// estadoDelPuerto = TipoRespuestaModem.WAIT;
// try {
// if (mode == 0) {
// // normal end of at command
// outStream.write((cmd + lfcr).getBytes());
// } else if (mode == 1) {
// // end of pdu <CTRL+Z>
//
// } else if (mode == 2) {
// // no lfcr: used for polling (just echoed back)
// outStream.write((cmd).getBytes());
// }
// outStream.flush();
// } catch (IOException e) {
// ;
// }
//
// // wait for response from device
// try {
// // Respond time can vary for different types of AT commands and
// // mobiles!
// portStatusLock.wait(timeout);
// } catch (InterruptedException e) {
// // ...
// }
// }
//
// return TipoRespuestaModem.OK;
// }
//
// /**
// * Terminates IR/Serial connection to Mobile device
// */
// public void close() {
// // Turn on again command echo
// atCmd("ATE1", 0, 1000);
// if (sPort != null) {
// try {
// // close the i/o streams.
// outStream.close();
// inStream.close();
// } catch (IOException e) {
// System.err.println(e);
// }
//
// // Close the port.
// sPort.close();
//
// // Remove the ownership listener.
// portId.removePortOwnershipListener(this);
// }
// }
//
// /**
// * Listener Function: Data received from serial link and interpreted
// */
// public void serialEvent(SerialPortEvent event) {
// switch (event.getEventType()) {
// case SerialPortEvent.BI:
// case SerialPortEvent.OE:
// case SerialPortEvent.FE:
// case SerialPortEvent.PE:
// case SerialPortEvent.CD:
// case SerialPortEvent.CTS:
// case SerialPortEvent.DSR:
// case SerialPortEvent.RI:
// case SerialPortEvent.OUTPUT_BUFFER_EMPTY:
// break;
// case SerialPortEvent.DATA_AVAILABLE:
// int n;
// try {
// if (POLLING_FLAG == false) {
// while ((n = inStream.available()) > 0) {
// n = inStream.read(readBuffer, bufferOffset, n);
// bufferOffset += n;
// String sbuf = new String(readBuffer, 0, bufferOffset); // bufferOffset-2
//
// // lfcr detected, line ready
// if (((readBuffer[bufferOffset - 1] == 10) && (readBuffer[bufferOffset - 2] ==
// 13))) {
// // analyzing mobile response
// lineReceived(sbuf);
// if ("ERROR".equals(portStatusMsg)) {
// System.out.println(portStatusMsg);
// logger.debug(portStatusMsg);
// }
// bufferOffset = 0;
// }
// }
//
// // delay 1/10 sec
// try {
// Thread.sleep(100);
// } catch (Exception ee) {
// }
// } else
// estadoDelPuerto = TipoRespuestaModem.ECHO;
// } catch (IOException e) {
// ;
// }
// break; // end: case SerialPortEvent.DATA_AVAILABLE:
// }
// }
//
// /**
// * Used for analyzing mobile response
// *
// * @throws IOException
// */
// private void lineReceived(String buffer) throws IOException {
// String response;
// StringTokenizer st = new StringTokenizer(buffer, "\r\n");
// mensajeEntrante = null;
// synchronized (portStatusLock) {
// while (st.hasMoreTokens()) {
// response = st.nextToken();
// logger.debug(response);
// System.out.println(response);
// if (response.startsWith("OK")) {
// estadoDelPuerto = TipoRespuestaModem.OK;
// portStatusLock.notify();
// } else if (response.startsWith(">")) {
// estadoDelPuerto = TipoRespuestaModem.WMSG;
// portStatusMsg = response;
// } else if (response.startsWith("ERROR")) {
// estadoDelPuerto = TipoRespuestaModem.ERROR;
// portStatusMsg = response;
// } else if (response.startsWith("+CME ERROR")
// || response.startsWith("+CMS ERROR")) {
// estadoDelPuerto = TipoRespuestaModem.ERROR;
// portStatusMsg = response;
// } else if (response.startsWith("+CPMS")) {
// // list sms SM, ME or MT
// estadoDelPuerto = TipoRespuestaModem.RMSG;
// portStatusMsg = response;
// } else if (response.startsWith(MENSAJES_RECIBIDOS_LEIDOS)
// || response.startsWith(MENSAJES_RECIBIDOS_NO_LEIDOS)) {
// // read sms OK
// estadoDelPuerto = TipoRespuestaModem.RMSG;
// portStatusMsg = response;
// mensajeEntrante = new MensajeEntrante(response);
// recibirMensaje = true;
// } else if (recibirMensaje) {
// try {
// mensajeEntrante.setMensaje(response);
// logger.debug("SMS received: "
// + mensajeEntrante.toString());
// portStatusLock.notify();
// } catch (RuntimeException e) { // TODO cambiar a la
// // excepcion copada
// logger.error("Error receiving SMS message: unable to parse PDU:\r\n"
// + response);
// estadoDelPuerto = TipoRespuestaModem.ERROR;
// } finally {
// recibirMensaje = false;
// }
// }
// // read phonebook response
// else if (response.startsWith("+CPBR")) // read index phonebook
// // OK
// {
// estadoDelPuerto = TipoRespuestaModem.RMSG;
// portStatusMsg = response;
// } else if (response.startsWith("+CPBS")) // read current
// // phonebook memory
// // OK
// {
// estadoDelPuerto = TipoRespuestaModem.RMSG;
// portStatusMsg = response;
// } else if (response.startsWith("+CPBF")) // read find phonebook
// // OK
// {
// estadoDelPuerto = TipoRespuestaModem.RMSG;
// portStatusMsg = response;
// }
// // other tips
// else if (response.startsWith("ATE0")) // snoop echo
// {
// estadoDelPuerto = TipoRespuestaModem.ECHO;
// portStatusMsg = response;
// } else {
// // ...
// }
// }
// }
// // }
// return;
// }
//
// public synchronized void enviarSMS(MensajeSaliente mensaje) {
// if (mensaje.getTelefono().startsWith("+"))
// mensaje.setTelefono(mensaje.getTelefono().substring(1));
//
// String cmd = "AT+CMGS=\"" + mensaje.getTelefono() + "\"";
//
// // Delay needed -> Waiting for ">" Prompt, otherwise Error MSG!
// atCmd(cmd, 0, 5000);
//
// if (this.getEstadoDelPuerto().esConError()) {
// logger.error("No pudo enviarse el mensaje a "
// + mensaje.getTelefono());
// throw new RuntimeException("No pudo enviarse el mensaje a "
// + mensaje.getTelefono());
// }
//
// // For some mobiles > 1000 ms!
// atCmd(mensaje.getMensaje(), 1, 3500);
//
// if (!this.estadoDelPuerto.esOK()) {
// logger.error("No pudo enviarse el mensaje a "
// + mensaje.getTelefono());
// throw new RuntimeException("No pudo enviarse el mensaje a "
// + mensaje.getTelefono());
// }
// }
//
// public synchronized MensajeEntrante leerSMS(int indiceSMS) {
// // obtengo el mensaje del modem
// atCmd("AT+CMGR=" + indiceSMS, 0, 2000);
//
// if (this.getEstadoDelPuerto().esConError()) {
// throw new RuntimeException(
// "Error al leer los mensajes recibidos. ["
// + this.getPortStatusMsg() + "]");
// }
//
// this.getRxMS().setIndice(indiceSMS);
//
// return this.getRxMS().clonar();
// }
//
// public synchronized void eliminarSMS(int indiceSMS) {
// atCmd("AT+CMGD=" + indiceSMS, 0, 1000); // Delete SMS
// }
//
// public synchronized MensajeEntrante getRxMS() {
// return mensajeEntrante;
// }
//
// /**
// * get error message & other...
// */
// public synchronized String getPortStatusMsg() {
// return portStatusMsg;
// }
//
// public synchronized TipoRespuestaModem getEstadoDelPuerto() {
// return estadoDelPuerto;
// }
//
// /**
// * Get current size list of SMS strored in particulary memory example =
// * \"ME\",\"SM\",\"MT\" "ME": ME phonebook "SM": SIM phonebook "MT":
// * combined ME and SIM phonebook
// *
// * @return int Size list of sms in specific memory
// */
// public synchronized int getSizeListSMS() {
// atCmd("AT+CPMS=" + currentMemory, 0, 500);
//
// // receive error message ?
// if (estadoDelPuerto.esConError()) {
// return 1; // index list start 1 not 0!
// }
//
// // parse response
// try {
// String str = portStatusMsg.substring(
// portStatusMsg.indexOf(':') + 1, portStatusMsg.length());
// String[] str2 = getArrayString(str);
// if (str2.length >= 2)
// str = str2[0]; // size used
// str = str.trim();
//
// // index current memory
// indexCurrentMemory = 1; // 1 for Sms
//
// return Integer.parseInt(str);
// } catch (java.lang.StringIndexOutOfBoundsException e) {
// return 1;
// } catch (NumberFormatException ee) {
// return 1;
// }
// }
//
// /**
// * Method getSmsMemory
// *
// * @return String Name of current sms memory
// */
// public synchronized String getSmsMemory() {
// String memory = "";
//
// // ask memory
// atCmd("AT+CPMS?", 0, 500);
//
// // receive error message ?
// if (estadoDelPuerto.esConError()) {
// return memory;
// }
//
// try {
// memory = portStatusMsg.substring(portStatusMsg.indexOf('"'),
// portStatusMsg.indexOf('"') + 4);
// memory = memory.trim();
//
// currentMemory = memory;
// } catch (java.lang.StringIndexOutOfBoundsException e) {
// return "";
// } catch (NumberFormatException ee) {
// return "";
// }
//
// return memory;
// }
//
// /**
// * Init current sms memory
// *
// * @param typeStore
// * @return boolean true if memory is initialized
// */
// public synchronized boolean initializeSmsMemory(String typeStore) {
// boolean initOk = true;
//
// // inint memory
// atCmd("AT+CPMS=" + typeStore, 0, 500);
//
// // receive error message ?
// if (estadoDelPuerto.esConError()) {
// throw new RuntimeException(
// "Ocurrio un error al quere inicializar el modo de almacenamiento.");
// }
//
// // set current type memory
// currentMemory = typeStore;
//
// return initOk;
// }
//
// /**
// * Get index of the current memory
// *
// * @return int
// */
// public int getIndexMemory() {
// return this.indexCurrentMemory;
// }
//
// /**
// * Method getArrayString
// *
// * @param response
// * @return String[]
// */
// private static String[] getArrayString(String _str) {
// // test _str
// if (_str == null)
// return new String[0];
// StringTokenizer b_stk = new StringTokenizer(_str, ",");
// String[] str = new String[b_stk.countTokens()];
// int count = 0;
// while (b_stk.hasMoreTokens())
// str[count++] = b_stk.nextToken();
// return str;
// }
//
// public List<MensajeEntrante> obtenerMensajesEntrantes() {
// List<MensajeEntrante> mensajes = new ArrayList<MensajeEntrante>();
// int cantidadDeMensajesNuevos = this.getSizeListSMS();
//
// for (int indiceSMS = 0; indiceSMS < cantidadDeMensajesNuevos; indiceSMS++) {
// // leo el mensaje
// mensajes.add(this.leerSMS(indiceSMS));
// }
//
// return mensajes;
// }
//
// /**
// * Main method SMS client.
// */
// public static void main(String[] args) {
// System.out.println(System.getProperty("java.home"));
// // Config serial port parameters!
// SerialParameters params = new SerialParameters();
// params.setPortName("/dev/ttyUSB1"); // default COM1
// params.setBaudRate(115200); // default 115200
// params.setFlowControlIn(SerialPort.FLOWCONTROL_NONE); // default none
// // flowcontrol
// params.setFlowControlOut(SerialPort.FLOWCONTROL_NONE); // default none
// // flowcontrol
// params.setDatabits(SerialPort.DATABITS_8); // default data bits 8
// params.setStopbits(SerialPort.STOPBITS_1); // default stop bits 1
// params.setParity(SerialPort.PARITY_NONE); // default none parity bits 1
//
// // object sms client
// ModemSMS sms = new ModemSMS(params);
//
// try {
// // lets use a single SerialComm object to initialize everything
// String[] portArray = sms.listPorts();
// System.out.println("Number of ports detected: " + portArray.length);
// for (int i = 0; i < portArray.length; i++) {
// System.out.println("OPEN serial Port : " + portArray[i]);
// }
// System.out.println();
//
// // open connection serial port
// sms.openConnection("/dev/ttyUSB1");// , "1111"); // COM1, optional
// // pin code
// boolean initMemSms = sms.initializeSmsMemory("\"ME\"");
//
// // Send a SMS with short message service center (french smsc by
// // example...)
// // Bouygues Telecom smsc = 33660003000
// // Orange smsc = 33689004000
// // SFR smsc = 33609001390
// // sms.SendMessage(new MensajeSaliente("1553235303",
// // "primer mensaje desde java"));
//
// // System.out.println(sms.getPortStatusMsg());
// // sms.SendMessage("3361xxxxxxx", "33660003000",
// // "Testing Network connection");
// // sms.SendMessage("62xxx", "33660003000", "CONTACT"); // call sms+
// // french service
//
// // store sms on SIM memory! (SM)
// // sms.WriteTextMessage("336xxxxxxxx", "33660003000", "coucou");
//
// // store sms on SIM memory! (ME) (simulated receive sms unread in
// // test!)
// // sms.WriteTextUnReadMessage("336xxxxxxxx", "33660003000",
// // "test1");
//
// // last message status ?
// // if (sms.getPortStatus() == ERROR)
// // System.out.println("----> Error : SMS not SEND !");
// // else if (sms.getPortStatus() == OK)
// // System.out.println("----> Ok : SMS SEND - check folder on SIM!");
//
// // init write memory sms "\"ME\",\"SM\",\"MT\"
// // System.out.println("Init Sms Memory  : " + initMemSms);
// //
// // // get size sms storage
// for (MensajeEntrante mensaje : sms.obtenerMensajesEntrantes()) {
//
// System.out.println();
// System.out.println("mensaje: " + mensaje.getMensaje());
// System.out.println("telefono: " + mensaje.getTelefono());
// System.out.println();
//
// sms.eliminarSMS(mensaje.getIndice());
// }
// //
// // // test if last message is a error
// // if (sms.getPortStatusMsg().startsWith("+CMS ERROR"))
// // break;
// //
// // // get incoming sms
// // MensajeEntrante in_sms = sms.getRxMS();
// //
// // if (in_sms != null) {
// // System.out.println("\nSMS received : " + in_sms.toString());
// // // sms.DeleteSMS(i);
// // } else
// // System.out.println("\nProblem SMS received !!!");
// // }
//
// // index , phone number, type, name
// // sms.WritePhoneBookMessage(8, "0xxxxxxxx", 129, "test one");
// // sms.DeletePhoneBook(8);
//
// } catch (IOException e) {
// System.err.println("Communication problem :" + e);
// e.printStackTrace();
// } finally {
// // close connection to serial port / modem
// try {
// sms.close();
// } catch (NullPointerException ex) {
// }
// }
// }
//
// }