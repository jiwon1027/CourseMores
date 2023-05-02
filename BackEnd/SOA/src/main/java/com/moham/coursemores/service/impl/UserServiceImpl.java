package com.moham.coursemores.service.impl;


import com.moham.coursemores.common.auth.oauth2.OAuthInfoResponse;
import com.moham.coursemores.common.auth.oauth2.OAuthLoginParams;
import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.service.OAuthApiClient;
import com.moham.coursemores.service.UserService;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class UserServiceImpl implements UserService {

    @Override
    public UserSimpleInfoResDto getUserSimpleInfo(Long userId) {
        return null;
    }
}
