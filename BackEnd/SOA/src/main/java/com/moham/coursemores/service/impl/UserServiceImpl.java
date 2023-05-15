package com.moham.coursemores.service.impl;

import com.moham.coursemores.common.auth.jwt.TokenProvider;
import com.moham.coursemores.common.exception.CustomErrorCode;
import com.moham.coursemores.common.exception.CustomException;
import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.dto.profile.UserInfoCreateReqDto;
import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.token.TokenReissueReqDto;
import com.moham.coursemores.dto.token.TokenResDto;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final FileUploadService fileUploadService;
    private final TokenProvider tokenProvider;

    @Override
    public UserInfoResDto getUserInfo(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(userId, CustomErrorCode.USER_NOT_FOUND));

        if (StringUtils.hasText(user.getNickname())
                && user.getAge() > 0
                && StringUtils.hasText(user.getGender()))
            return UserInfoResDto.builder()
                    .nickname(user.getNickname())
                    .gender(user.getGender())
                    .age(user.getAge())
                    .profileImage(user.getProfileImage())
                    .build();

        return null;
    }

    @Override
    public String generateToken(Long userId, OAuthProvider oAuthProvider) {
        return tokenProvider.generateAccessToken(Long.toString(userId), oAuthProvider);
    }

    @Override
    public boolean isDuplicatedNickname(String nickname) {
        return userRepository.existsByNicknameAndDeleteTimeIsNull(nickname);
    }

    @Override
    @Transactional
    public void addUserInfo(Long userId, UserInfoCreateReqDto userInfoCreateReqDto, MultipartFile profileImage) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(userId,CustomErrorCode.USER_NOT_FOUND));

        String imageUrl = "default";
        // 선택한 이미지가 있다면 업로드
        if (profileImage != null)
            imageUrl = fileUploadService.uploadImage(profileImage);

        user.create(userInfoCreateReqDto, imageUrl);
    }

    @Override
    public Map<String, Object> reissue(TokenReissueReqDto tokenReissueReqDto) {
        Long userId = tokenProvider.extractMemberId(tokenReissueReqDto.getAccessToken());

        if(userId == null)
            throw new CustomException(tokenReissueReqDto.getAccessToken(),CustomErrorCode.TOKEN_NOT_VALID);

        Optional<User> temp = userRepository.findByIdAndDeleteTimeIsNull(userId);

        if(temp.isEmpty() || !temp.get().getNickname().equals(tokenReissueReqDto.getNickname())){
            throw new CustomException(userId,CustomErrorCode.USER_NOT_FOUND);
        }

        Map<String, Object> resultMap = new HashMap<>();

        String accessToken = tokenProvider.generateAccessToken(Long.toString(userId), temp.get().getProvider());
        resultMap.put("accessToken", accessToken);

        User user = temp.get();
        resultMap.put("userInfo",UserInfoResDto.builder()
                .age(user.getAge())
                .profileImage(user.getProfileImage())
                .gender(user.getGender())
                .nickname(user.getNickname())
                .build());

        return resultMap;
    }


}