package com.moham.coursemores.service.impl;


import com.moham.coursemores.domain.User;
import com.moham.coursemores.dto.profile.UserInfoCreateReqDto;
import com.moham.coursemores.dto.profile.UserInfoResDto;
import com.moham.coursemores.dto.profile.UserSimpleInfoResDto;
import com.moham.coursemores.repository.UserRepository;
import com.moham.coursemores.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final FileUploadService fileUploadService;

    @Override
    public UserInfoResDto getUserProfile(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("해당 유저를 찾을 수 없습니다."));
        return UserInfoResDto.builder()
                .age(user.getAge())
                .gender(user.getGender())
                .nickname(user.getNickname())
                .profileImage(user.getProfileImage())
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
        if(profileImage != null)
            imageUrl = fileUploadService.uploadImage(profileImage);

        user.create(userInfoCreateReqDto, imageUrl);
    }
}
