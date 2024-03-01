package progetto.server.beans;

public class Response {
    private Boolean result;
    private Object data;
    private String error;

    public Response(Boolean result, Object data, String error) {
        this.result = result;
        this.data = data;
        this.error = error;
    }

    public Response(Boolean result, Object data) {
        this(result, data, null);
    }

    public Response(String error) {
        this(false, null, error);
    }

    public Response() {
    }

    public Boolean getResult() {
        return result;
    }

    public void setResult(Boolean result) {
        this.result = result;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

}
