package com.coursemores.service.service.impl;

import com.coursemores.service.dto.profile.UserSimpleInfoResDto;
import com.coursemores.service.service.UserService;
import lombok.NoArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@NoArgsConstructor
public class UserServiceImpl implements UserService {

    @Override
    public UserSimpleInfoResDto getUserSimpleInfo(Long userId) {
        return null;
    }
}