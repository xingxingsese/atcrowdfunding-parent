package com.atguigu.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.atguigu.api.UserService;
import com.atguigu.bean.Admin;
import com.atguigu.bean.User;
import com.atguigu.mapper.AdminMapper;


@Service
public class UserServiceImpl implements UserService {

	@Autowired
	AdminMapper adminMapper;

	@Override
	public User getUserById(Long id) {
		// TODO Auto-generated method stub
		
		
		return null;
	}

	@Override
	public User getUserByUsernameAndPassword() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public Admin getAdmin(Integer id) {
		// TODO Auto-generated method stub
		Admin admin = adminMapper.getAdminById(id);
		return admin;
	}

}
