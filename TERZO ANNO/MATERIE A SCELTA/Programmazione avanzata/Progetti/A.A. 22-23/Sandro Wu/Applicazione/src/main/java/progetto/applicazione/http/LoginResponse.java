package progetto.applicazione.http;

import java.util.Date;

public class LoginResponse {
    boolean result;
    String token;
    Date expiration;

    public LoginResponse() {
    }

    public LoginResponse(boolean result, String token, Date expiration) {
        this.result = result;
        this.token = token;
        this.expiration = expiration;
    }

    public boolean isResult() {
        return result;
    }

    public void setResult(boolean result) {
        this.result = result;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public Date getExpiration() {
        return expiration;
    }

    public void setExpiration(Date expiration) {
        this.expiration = expiration;
    }

}
