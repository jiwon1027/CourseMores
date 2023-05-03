package com.moham.coursemores.service;

import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;

public interface UserService {
    UserSimpleInfoResDto getUserSimpleInfo(Long userId);
}
