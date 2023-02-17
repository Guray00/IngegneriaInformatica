package progetto.applicazione;

import progetto.applicazione.exception.InitDBException;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.apache.ibatis.jdbc.RuntimeSqlException;
import org.apache.ibatis.jdbc.SQL;
import org.apache.ibatis.jdbc.ScriptRunner;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class InitDB {
	private static Logger log = LogManager.getLogger();

	private static final String dataFileName = "data.json";
	private static final String sqlFileName = "create_table.sql";
	private static final String connString = "jdbc:mysql://127.0.0.1:3306/CloudServicesManager?createDatabaseIfNotExist=true";
	private static final String sqlUser = "root";
	private static final String sqlPass = "root";

	/**
	 * Create DB from sql file and populate it with data.json
	 */
	public static void initialize() throws InitDBException {

		String dataFile, sqlFile;
		try {
			dataFile = App.class.getResource(dataFileName).getPath();
			sqlFile = App.class.getResource(sqlFileName).getPath();
		} catch (Exception e) {
			throw new InitDBException("data json file or sql file not found");
		}
		/* ---------------------------- READ DATA FILE --------------------------- */
		// Get data.json file

		JsonObject json = null;

		log.info("reading data.json");
		try {
			FileReader file = new FileReader(dataFile);
			json = JsonParser.parseReader(file).getAsJsonObject();

		} catch (IOException e) {
			log.error("Failed reading " + dataFile);
			throw new InitDBException();
		}

		/* -------------------------------- DATABASE -------------------------------- */

		try (Connection conn = DriverManager.getConnection(connString, sqlUser, sqlPass)) {

			/* ---------------------------- DATABASE CREATION --------------------------- */
			// Creating Tables from sql file

			log.info("reading sql file");
			Reader reader = new BufferedReader(new FileReader(sqlFile));

			try {
				ScriptRunner sr = new ScriptRunner(conn);
				sr.setStopOnError(true);
				sr.runScript(reader);
			} catch (RuntimeSqlException e) {
				throw new InitDBException("Error executing sql file");
			}

			log.info("Tables created");
			/* --------------------------- DATABASE POPULATION -------------------------- */
			// read from data.json and insert

			log.info("Inserting data");
			for (String tableName : json.keySet()) {
				log.info(tableName);

				JsonArray rows = json.get(tableName).getAsJsonArray();

				for (JsonElement el : rows) {
					JsonObject row = el.getAsJsonObject();

					// SQL Builder
					SQL sql = new SQL().INSERT_INTO(tableName);
					for (String colName : row.keySet()) {
						String value = row.get(colName).toString();
						sql.VALUES(colName, value);
					}

					conn.prepareStatement(sql.toString()).executeUpdate();
				}

			}

			conn.commit();
			log.info("DB initialized");

		} catch (SQLException e) {
			log.error("Connection failed " + e);
			throw new InitDBException();
		} catch (FileNotFoundException ex) {
			log.error("Failed getting " + sqlFile);
			throw new InitDBException();
		}
	}
}
