package com.atguigu.atcrowdfunding.listener;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AppStartupListener implements ServletContextListener {
	Logger logger = LoggerFactory.getLogger(AppStartupListener.class);

	/**
	 * 项目销毁
	 */
	@Override
	public void contextDestroyed(ServletContextEvent sce) {

	}

	/**
	 * 项目初始化:给application域中保存项目路径
	 */
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		// 一个项目一个servletcontext 这个对象就代表当前项目
		ServletContext servletContext = sce.getServletContext();

		// 当前项目路径以/开始,不以/结束
		String contextPath = servletContext.getContextPath();
		// 把路径存到域中
		servletContext.setAttribute("ctx", contextPath);

		logger.info("项目启动成功...访问路径是{}", contextPath);

	}

}
