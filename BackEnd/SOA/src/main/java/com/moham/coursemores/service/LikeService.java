package com.moham.coursemores.service;

public interface LikeService {

    boolean checkLikeCourse(int userId, int courseId);

    void addLikeCourse(int userId, int courseId);

    void deleteLikeCourse(int userId, int courseId);

    boolean checkLikeComment(int userId, int commentId);

    void addLikeComment(int userId, int commentId);

    void deleteLikeComment(int userId, int commentId);

}