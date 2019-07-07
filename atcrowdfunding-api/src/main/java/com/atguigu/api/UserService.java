package com.atguigu.api;

import com.atguigu.bean.Admin;
import com.atguigu.bean.User;

public interface UserService {
	
	User getUserById(Long id);
	
	User getUserByUsernameAndPassword();

	Admin getAdmin(Integer id);
	
	
	

}
