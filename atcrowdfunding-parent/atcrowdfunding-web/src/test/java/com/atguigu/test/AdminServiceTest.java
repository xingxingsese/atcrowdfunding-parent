package com.atguigu.test;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.atguigu.atcrowdfunding.api.AdminService;
import com.atguigu.atcrowdfunding.bean.TAdmin;
/**
 * 引入spring的单元测试
 * 	junit 和sping-test
 * 将普通的单元测试变成spring的单元测试
 *  @RunWith告诉junit使用那个驱动这个测试
 *  ContextConfiguration 告诉spring当前的单元测试类用哪些配置文件
 *  
 * @author DELL
 *
 */

@ContextConfiguration(locations = {"classpath*:spring-beans.xml","classpath*:spring-mybatis.xml","classpath*:spring-tx.xml"})
@RunWith(SpringJUnit4ClassRunner.class)
public class AdminServiceTest {

	@Autowired
	AdminService adminService;
	
	@Test
	public void pageTest() {
		List<TAdmin> admin = adminService.listAllAdmin();
		System.out.println(admin.size());
	}
}
