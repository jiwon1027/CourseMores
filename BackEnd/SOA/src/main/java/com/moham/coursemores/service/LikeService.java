package com.moham.coursemores.service;

public interface LikeService {
    boolean checkLikeCourse(Long userId, Long courseId);
    void addLikeCourse(Long userId, Long courseId);
    void deleteLikeCourse(Long userId, Long courseId);
    boolean checkLikeComment(Long userId, Long commentId);
    void addLikeComment(Long userId, Long commentId);
    void deleteLikeComment(Long userId, Long commentId);
}