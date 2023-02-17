package progetto.applicazione.exception;

public class HttpException extends Exception {
    Integer code;

    public HttpException(String string) {
        super(string);
    }

    public HttpException(Integer code) {
        super(Integer.toString(code));
        this.code = code;
    }

    public Integer getCode() {
        return code;
    }

}
