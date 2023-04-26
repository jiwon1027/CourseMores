package com.moham.coursemores.service.impl;


import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.service.UserService;
import lombok.NoArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@NoArgsConstructor
public class UserServiceImpl implements UserService {

    @Override
    public UserSimpleInfoResDto getUserSimpleInfo(int userId) {
        return null;
    }
}
