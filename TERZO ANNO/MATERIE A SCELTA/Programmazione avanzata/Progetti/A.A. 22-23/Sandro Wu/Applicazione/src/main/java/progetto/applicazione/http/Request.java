/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package progetto.applicazione.http;

import progetto.applicazione.exception.HttpException;
import progetto.applicazione.exception.UnauthorizedException;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 *
 * @author sandro
 */
public class Request {

	public static final String ServerURL = "http://127.0.0.1:8080/api/v1";

	private static final Logger log = LogManager.getLogger(Request.class);

	public static String get(String path, String token) throws HttpException, UnauthorizedException {
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create(ServerURL + path))
				.header("Accept", "application/json")
				.header("Content-type", "application/json")
				.header("Authorization", "Bearer " + token)
				.GET()
				.build();

		String responseBody = send(request);
		return responseBody;
	}

	public static String delete(String path, String token) throws HttpException, UnauthorizedException {
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create(ServerURL + path))
				.header("Accept", "application/json")
				.header("Content-type", "application/json")
				.header("Authorization", "Bearer " + token)
				.DELETE()
				.build();

		String responseBody = send(request);
		return responseBody;
	}

	public static String post(String path, String jsonString) throws HttpException, UnauthorizedException {
		return post(path, jsonString, null);
	}

	public static String post(String path, String jsonString, String token)
			throws HttpException, UnauthorizedException {
		HttpRequest request = HttpRequest.newBuilder()
				.uri(URI.create(ServerURL + path))
				.header("Accept", "application/json")
				.header("Content-type", "application/json")
				.header("Authorization", "Bearer " + token)
				.POST(HttpRequest.BodyPublishers.ofString(jsonString))
				.build();

		String responseBody = send(request);
		return responseBody;
	}

	private static String send(HttpRequest request) throws HttpException, UnauthorizedException {
		try {
			HttpResponse<String> response = HttpClient.newHttpClient()
					.send(request, HttpResponse.BodyHandlers.ofString());

			if (response.statusCode() != 200) {
				log.warn(request.method() + " " + request.uri() +
						" request got response code: " + response.statusCode());
			}

			if (response.statusCode() == 401) {
				throw new UnauthorizedException();
			}

			return response.body();

		} catch (IOException | InterruptedException e) {
			log.error("Could not connect to the server: " + e);
			throw new HttpException("Could not connect to the server");
		}
	}

}
