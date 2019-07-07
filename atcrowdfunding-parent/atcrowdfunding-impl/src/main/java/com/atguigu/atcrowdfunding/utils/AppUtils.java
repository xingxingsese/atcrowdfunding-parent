package com.atguigu.atcrowdfunding.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.util.DigestUtils;

/**
 * 给密码加密的工具类
 * 
 * @author DELL
 *
 */
public class AppUtils {
	//密码加密
	public static String getDigestPwd(String str) {
		String string = str;
		for (int i = 0; i < 100; i++) {
			string = DigestUtils.md5DigestAsHex(string.getBytes());
		}

		return string;
	}
	//获取当前时间的字符串
	public static String getCurrentTimeStr() {
		//获取当前时间
		//Date date = new Date();
		//简单格式化工具
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss ");
		
		return format.format(new Date());
	}
	//获取指定时间的字符串
	public static String getCurrentTimeStr(Date date) {
		
		//简单格式化工具
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss ");
		
		return format.format(date);
	}
	//获取指定时间的字符串,指定格式的
		public static String getCurrentTimeStr(Date date,String pattern) {
			
			//简单格式化工具
			SimpleDateFormat format = new SimpleDateFormat(pattern);
			
			return format.format(date);
		}
}
