package com.moham.coursemores.common.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CustomErrorCode {

    USER_NOT_FOUND("유저를 찾을 수 없습니다."),
    COURSE_NOT_FOUND("코스를 찾을 수 없습니다."),
    COURSE_LOCATION_NOT_FOUND("코스의 지역을 찾을 수 없습니다."),
    COURSE_LOCATION_IMAGE_NOT_FOUND("코스의 지역의 사진을 찾을 수 없습니다."),
    COMMENT_NOT_FOUND("댓글을 찾을 수 없습니다."),
    COMMENT_IMAGE_NOT_FOUND("댓글의 사진을 찾을 수 없습니다."),
    INTEREST_COURSE_NOT_FOUND("코스 관심 내역을 찾을 수 없습니다."),
    LIKE_COURSE_NOT_FOUND("코스 좋아요 내역을 찾을 수 없습니다."),
    LIKE_COMMENT_NOT_FOUND("댓글 좋아요 내역을 찾을 수 없습니다."),
    THEME_NOT_FOUND("테마를 찾을 수 없습니다."),
    REGION_NOT_FOUND("지역을 찾을 수 없습니다."),
    NOTIFICATION_NOT_FOUND("알림을 찾을 수 없습니다."),
    FIREBASE_TOKEN_NOT_FOUND("파이어베이스 토큰을 찾을 수 없습니다."),

    NOTIFICATION_NOT_DELETE("알림을 삭제할 수 없습니다."),
    TOKEN_NOT_VALID("토큰이 유효하지 않습니다."),
    ALREADY_DELETE_COURSE("삭제된 코스입니다."),
    SECURITY_CONTEXT_NOT_FOUND("인증 정보가 없습니다."),

    FAIL_SEND_NOTIFICATION("알림 전송에 실패하였습니다."),
    FAIL_UPLOAD_IMAGE("사진 업로드에 실패하였습니다."),

    ALREADY_REGISTER_INTEREST_COURSE("이미 관심 등록된 코스입니다."),
    ALREADY_RELEASE_INTEREST_COURSE("이미 관심 해제된 코스입니다."),
    ALREADY_REGISTER_LIKE_COURSE("이미 좋아요 등록된 코스입니다."),
    ALREADY_RELEASE_LIKE_COURSE("이미 좋아요 해제된 코스입니다."),


    ;

    private final String statusMessage;
}
