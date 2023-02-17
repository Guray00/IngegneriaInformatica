open module progetto.applicazione {
	requires javafx.controls;
	requires javafx.fxml;
	requires java.base;
	requires java.net.http;
	requires java.sql;
	requires mysql.connector.java;
	requires org.mybatis;
	requires com.google.gson;
	requires org.apache.logging.log4j;
	requires org.apache.httpcomponents.httpclient;
	requires org.apache.httpcomponents.httpcore;

	requires org.testfx.junit5;

	requires transitive javafx.graphics;

	// opens progetto.applicazione to javafx.fxml;
	// opens progetto.applicazione.manager; // to javafx.fxml, javafx.base,
	// com.google.gson;
	// opens progetto.applicazione.manager.beans; // to javafx.fxml, javafx.base,
	// com.google.gson;
	// opens progetto.applicazione.http to com.google.gson;

	exports progetto.applicazione;
}
