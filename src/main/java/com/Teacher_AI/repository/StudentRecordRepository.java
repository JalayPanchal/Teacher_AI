package com.Teacher_AI.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.Teacher_AI.entity.StudentRecordEntity;

public interface StudentRecordRepository
        extends JpaRepository<StudentRecordEntity, Integer> {

    List<StudentRecordEntity> findByDocumentId(
            Integer documentId
    );

    List<StudentRecordEntity> findByDocumentIdAndNameContainingIgnoreCase(
            Integer documentId,
            String name
    );

    List<StudentRecordEntity> findByDocumentIdAndRollNoContainingIgnoreCase(
            Integer documentId,
            String rollNo
    );

    List<StudentRecordEntity> findByDocumentIdAndClassName(
            Integer documentId,
            String className
    );
}