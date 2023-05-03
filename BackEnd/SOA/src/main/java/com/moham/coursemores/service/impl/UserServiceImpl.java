package com.moham.coursemores.service.impl;


import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.service.UserService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
public class UserServiceImpl implements UserService {

    @Override
    public UserSimpleInfoResDto getUserSimpleInfo(Long userId) {
        return null;
    }
}
