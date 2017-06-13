package services;

import java.security.MessageDigest;

public class Encryption {

	public static String hash(String input){
		
		try{
			
			MessageDigest md = MessageDigest.getInstance("SHA-1");
			byte[] result = md.digest(input.getBytes());
			StringBuffer sb = new StringBuffer();
			
			for(int i = 0; i < result.length; i++) {
				sb.append(Integer.toString((result[i] & 0xff) + 0x100, 16).substring(1));
			}
			
			return sb.toString();
			
		}catch(Exception e){
			return null;
		}
	}

}
