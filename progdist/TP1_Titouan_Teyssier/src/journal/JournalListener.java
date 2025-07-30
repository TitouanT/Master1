/*
 * JournalListener.java
 *
 * Created on 5 juillet 2007, 10:13
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package journal;

import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;
import javax.jms.JMSException;
import journal.JournalPersistance;
import java.io.File;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

/**
 *
 * @author lemeunie
 */
public class JournalListener implements MessageListener {

	public void onMessage(Message message) {
		if (message instanceof TextMessage) {
			TextMessage msg = (TextMessage) message;
			String xml = "";
			try {
				System.out.println(JournalListener.toConsole(msg));
				xml = JournalListener.toXML(msg);
			} catch (JMSException exception) {
				System.err.println("Failed to get message text: " + exception);
			}
			try {
				JournalListener.saveToDisk(xml);
			} catch (IOException exception) {
				System.err.println("Failed to write to disk: " + exception);
			}
		}
	}

	public static String toXML(TextMessage msg) throws JMSException {
		// <event><text>hello</text><login>cl1</login><appName> myapp</appName><machine>mycopmpuer</machine></event>
		return "<event><text>" + msg.getText() + "</text><login>" + msg.getStringProperty("login") + "</login><appName>" + msg.getStringProperty("applicationName") + "</appName><machine>" + msg.getStringProperty("machineName") + "</machine></event>\n";
	}

	public static String toConsole(TextMessage msg) throws JMSException {
		// <event><text>hello</text><login>cl1</login><appName> myapp</appName><machine>mycopmpuer</machine></event>
		return "Received: " + msg.getText() + "\n\tlogin: " + msg.getStringProperty("login") + "\n\tapp: " + msg.getStringProperty("applicationName") + "\n\tmachine: " + msg.getStringProperty("machineName");
	}

	public static void saveToDisk(String xmlstr) throws IOException {
		final String filename = "./journalLog.xml";
		File file = new File(filename);
		if (!file.exists()) {
			String fileContent = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
			BufferedWriter writer = new BufferedWriter(new FileWriter(filename));
			writer.write(fileContent);
			writer.close();
		}

		BufferedWriter writer = new BufferedWriter(new FileWriter(filename, true));
		writer.write(xmlstr);
		writer.close();

	}

}
