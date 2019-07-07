package com.atguigu.test;

import org.junit.Test;
import org.springframework.util.DigestUtils;

public class MD5Test {

	@Test
	public void md5Test() {
		String string = DigestUtils.md5DigestAsHex("123123".getBytes());
		System.out.println(string);
	}
}
