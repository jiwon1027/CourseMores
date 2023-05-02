package com.coursemores.service.service;


import com.coursemores.service.dto.profile.UserSimpleInfoResDto;

public interface UserService {

    UserSimpleInfoResDto getUserSimpleInfo(Long userId);
}