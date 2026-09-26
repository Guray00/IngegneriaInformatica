package progetto.applicazione.manager;

import java.util.Date;

public class UserSession {

	private static UserSession instance;

	private String username;
	private String token;
	private Date expiration;

	public UserSession(String username, String token, Date expiration) {
		this.username = username;
		this.token = token;
		this.expiration = expiration;
	}

	synchronized public static UserSession setInstance(String username, String token, Date expiration) {
		if (instance == null) {
			instance = new UserSession(username, token, expiration);
		} else {
			instance.username = username;
			instance.token = token;
			instance.expiration = expiration;
		}
		return instance;
	}

	public static UserSession getInstance() {
		return instance;
	}

	public static String getInstanceToken() {
		return instance != null ? instance.token : null;
	}

	public static String getInstanceUsername() {
		return instance != null ? instance.username : null;
	}

	public static Date getInstanceExpiration() {
		return instance != null ? instance.expiration : null;
	}

	public String getToken() {
		return token;
	}

	public String getUsername() {
		return username;
	}

	public Date getExpiration() {
		return expiration;
	}

}
