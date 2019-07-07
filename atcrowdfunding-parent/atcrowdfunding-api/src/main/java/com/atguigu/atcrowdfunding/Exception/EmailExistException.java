package com.atguigu.atcrowdfunding.Exception;
/**
 * 邮箱以存在异常
 * @author DELL
 *
 */
public class EmailExistException extends RuntimeException{

	private static final long serialVersionUID = 1L;

	public EmailExistException() {
		super("邮箱已经存在");
		// TODO Auto-generated constructor stub
	}

	public EmailExistException(String message) {
		super(message);
		// TODO Auto-generated constructor stub
	}

	
}
