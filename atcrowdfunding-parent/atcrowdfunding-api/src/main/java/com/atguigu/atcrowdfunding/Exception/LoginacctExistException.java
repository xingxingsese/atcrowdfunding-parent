package com.atguigu.atcrowdfunding.Exception;
/**
 * 帐号已存在异常
 * @author DELL
 *
 */
public class LoginacctExistException extends RuntimeException{

	private static final long serialVersionUID = 1L;
	
	public LoginacctExistException(String message) {
		super(message);
	}
	
	public LoginacctExistException() {
		super("帐号已经存在");
	}
	
}
