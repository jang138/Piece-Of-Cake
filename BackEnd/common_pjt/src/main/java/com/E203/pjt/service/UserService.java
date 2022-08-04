package com.E203.pjt.service;

import java.util.List;

import com.E203.pjt.model.dto.req.UserReqVO;
import com.E203.pjt.model.dto.res.UserResVO;
import com.E203.pjt.model.entity.User;

public interface UserService {
  UserResVO createUser(UserReqVO userReqVO);
  void deleteUser(Integer user_seq);
  List<User> getAllUsers();
}
