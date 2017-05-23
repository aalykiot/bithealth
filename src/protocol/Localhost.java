package protocol;

public class Localhost {
	
	private static String Url = "http://localhost:";
	private static String Port = "8080";
	
	public String getUrl(){
		return (Url+Port);
	}
	
}
