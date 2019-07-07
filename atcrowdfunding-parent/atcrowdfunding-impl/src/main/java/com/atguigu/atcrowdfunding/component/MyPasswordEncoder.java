package com.atguigu.atcrowdfunding.component;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import com.atguigu.atcrowdfunding.utils.AppUtils;

/**
 * 自定义的密码加密器
 * 必须实现org.springframework.security.crypto.password.PasswordEncoder; 这个接口
 * @author DELL
 *
 */
@Component("myPasswordEncoder")//给组件取id
public class MyPasswordEncoder implements PasswordEncoder{
	
	/**
	 * 将明文密码转为密文
	 */
	@Override
	public String encode(CharSequence rawPaword) {
		//调用自定义的工具类,对明文密码转为密文
		String digestPwd = AppUtils.getDigestPwd(rawPaword.toString());
		return digestPwd;
	}
	/**
	 * 明文密文匹配方法 也就是判断两个密码是否相等
	 * 
	 */
	@Override
	public boolean matches(CharSequence rawPaword, String encodePassword) {
		// TODO Auto-generated method stub
		String digestPwd = AppUtils.getDigestPwd(rawPaword.toString());
		return digestPwd.equals(encodePassword);
	}

}
