package com.moham.coursemores.repository;

import com.moham.coursemores.domain.Notification;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;

public interface NotificationRepository extends JpaRepository<Notification, Long> {

    List<Notification> findByUserIdAndDeleteTimeIsNull(long userId);

}