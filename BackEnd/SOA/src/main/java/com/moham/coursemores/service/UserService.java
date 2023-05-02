package com.moham.coursemores.service;

import com.moham.coursemores.common.auth.oauth2.OAuthInfoResponse;
import com.moham.coursemores.common.auth.oauth2.OAuthLoginParams;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;

public interface UserService {
    UserSimpleInfoResDto getUserSimpleInfo(Long userId);
}
