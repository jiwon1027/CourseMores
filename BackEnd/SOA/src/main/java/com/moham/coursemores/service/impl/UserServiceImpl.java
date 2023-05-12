package com.moham.coursemores.service.impl;

import com.moham.coursemores.common.auth.jwt.TokenProvider;
import com.moham.coursemores.common.util.OAuthProvider;
import com.moham.coursemores.domain.User;
import com.moham.coursemores.domain.redis.RefreshToken;
import com.moham.coursemores.dto.profile.UserInfoCreateReqDto;
import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.token.TokenReissueReqDto;
import com.moham.coursemores.dto.token.TokenResDto;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.RefreshService;
import com.moham.coursemores.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final FileUploadService fileUploadService;
    private final TokenProvider tokenProvider;
    private final RefreshService refreshService;

    @Override
    public UserInfoResDto getUserInfo(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));

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
    public TokenResDto generateToken(Long userId, OAuthProvider oAuthProvider) {
        String accessToken = tokenProvider.generateAccessToken(Long.toString(userId), oAuthProvider);
        String refreshToken = tokenProvider.generateRefreshToken();

        return TokenResDto.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build();
    }

    @Override
    public boolean isDuplicatedNickname(String nickname) {
        return userRepository.existsByNicknameAndDeleteTimeIsNull(nickname);
    }

    @Override
    @Transactional
    public void addUserInfo(Long userId, UserInfoCreateReqDto userInfoCreateReqDto, MultipartFile profileImage) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));

        String imageUrl = "default";
        // 선택한 이미지가 있다면 업로드
        if (profileImage != null)
            imageUrl = fileUploadService.uploadImage(profileImage);

        user.create(userInfoCreateReqDto, imageUrl);
    }

    @Override
    public String reissue(TokenReissueReqDto tokenReissueReqDto) {
        // 1. Refresh Token 검증
        if (!tokenProvider.validate(tokenReissueReqDto.getRefreshToken())) {
            throw new RuntimeException("해당 Refresh Token이 유효하지 않습니다.");
        }

        // 2. Access Token 에서 Member ID 가져오기
        Long userId = tokenProvider.extractMemberId(tokenReissueReqDto.getAccessToken());
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("해당 사용자를 찾을 수 없습니다."));

        // 3. 저장소에서 Member ID 를 기반으로 Refresh Token 값 가져옴
        RefreshToken originRefreshToken = refreshService.get(userId); // 로그아웃 시 DB에서 리프레쉬 토큰을 제거한다는 가정하에

        // 4. Refresh Token 일치하는지 검사
        if (!originRefreshToken.getRefreshToken().equals(tokenReissueReqDto.getRefreshToken())) {
            throw new RuntimeException("해당 Refresh Token이 일치하지 않습니다.");
        }

        // 5. 새로운 accessToken 생성
        String newAccessToken = tokenProvider.generateAccessToken(Long.toString(userId), user.getProvider());

        // 토큰 발급
        return newAccessToken;
    }

}