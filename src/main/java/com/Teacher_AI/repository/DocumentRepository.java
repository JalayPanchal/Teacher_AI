package com.Teacher_AI.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Teacher_AI.entity.DocumentEntity;

public interface DocumentRepository extends JpaRepository<DocumentEntity, Integer> {

    List<DocumentEntity> findByUserId(Integer userId);
    
    List<DocumentEntity> findByUserIdAndFileNameContainingIgnoreCase(
            Integer userId,
            String fileName
    );
}