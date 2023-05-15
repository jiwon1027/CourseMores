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

import javax.security.auth.message.AuthException;
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
    public Map<String, Object> reissue(TokenReissueReqDto tokenReissueReqDto) {
        Long userId = tokenProvider.extractMemberId(tokenReissueReqDto.getAccessToken());

        if(userId == null)
            throw new RuntimeException("해당 토큰이 유효하지 않습니다.");

        Optional<User> temp = userRepository.findByIdAndDeleteTimeIsNull(userId);

        if(temp.isEmpty() || !temp.get().getNickname().equals(tokenReissueReqDto.getNickname())){
            throw new RuntimeException("해당 유저를 찾을 수 없습니다.");
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

//    @Override
//    public String reissue(TokenReissueReqDto tokenReissueReqDto) {
//        Long userId = tokenProvider.extractMemberId(tokenReissueReqDto.getAccessToken());
//        Optional<User> user = userRepository.findById(userId);
//        if(user.isEmpty()){
//            return "401";
//        }
//
//        // 3. 저장소에서 Member ID 를 기반으로 Refresh Token 값 가져옴
//        Optional<RefreshToken> originRefreshToken = refreshService.get(userId); // 로그아웃 시 DB에서 리프레쉬 토큰을 제거한다는 가정하에
//
//        // 4. Refresh Token 일치하는지 검사
//        if (originRefreshToken.isEmpty() || !originRefreshToken.get().getRefreshToken().equals(tokenReissueReqDto.getRefreshToken())) {
//            return "401";
//        }
//
//        // 토큰 발급
//        return tokenProvider.generateAccessToken(Long.toString(userId), user.get().getProvider());
//    }
}