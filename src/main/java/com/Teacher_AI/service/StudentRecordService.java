package com.Teacher_AI.service;

import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import com.Teacher_AI.entity.StudentRecordEntity;
import com.Teacher_AI.repository.StudentRecordRepository;

@Service
public class StudentRecordService {

    private final StudentRecordRepository studentRecordRepository;

    private String getValue(
            JSONObject row,
            String... possibleKeys) {

        for (String key : possibleKeys) {

            if (row.has(key)
                    && !row.isNull(key)) {

                return row.optString(key, null);
            }
        }

        return null;
    }
    
    public StudentRecordService(
            StudentRecordRepository studentRecordRepository) {

        this.studentRecordRepository =
                studentRecordRepository;
    }

    public void saveStudentRecords(
            Integer documentId,
            String structuredDataJson) {

        if (structuredDataJson == null
                || structuredDataJson.isBlank()) {

            return;
        }

        JSONObject json =
                new JSONObject(structuredDataJson);

        boolean isStructured =
                json.optBoolean(
                        "isStructured",
                        false
                );

        String type =
                json.optString(
                        "type",
                        ""
                );

        if (!isStructured) {

            System.out.println(
                    "Document is not structured data."
            );

            return;
        }

        String normalizedType =
                type.toLowerCase()
                    .replace("_", " ")
                    .trim();

        if (!normalizedType.contains("student")
                || (!normalizedType.contains("mark")
                    && !normalizedType.contains("record"))) {

            System.out.println(
                    "Document is structured data, but not student records."
            );

            return;
        }
        JSONArray rows =
                json.optJSONArray("rows");

        if (rows == null || rows.isEmpty()) {

            System.out.println(
                    "No student rows found."
            );

            return;
        }

        for (int i = 0; i < rows.length(); i++) {

            JSONObject row = rows.getJSONObject(i);

            StudentRecordEntity student =
                    new StudentRecordEntity();

            student.setDocumentId(documentId);

            String rollNo = getValue(
                    row,
                    "roll_no",
                    "rollNo",
                    "roll no",
                    "id",
                    "ID"
            );

            String name = getValue(
                    row,
                    "name",
                    "Name",
                    "student_name",
                    "Student Name"
            );

            String className = getValue(
                    row,
                    "class",
                    "Class",
                    "class_name",
                    "Class Name"
            );

            String marks = getValue(
                    row,
                    "marks",
                    "Marks",
                    "total_marks",
                    "Total Marks"
            );

            String percentage = getValue(
                    row,
                    "percentage",
                    "Percentage",
                    "attendance",
                    "Attendance"
            );

            student.setRollNo(rollNo);
            student.setName(name);
            student.setClassName(className);
            student.setMarks(marks);
            student.setPercentage(percentage);

            studentRecordRepository.save(student);
        }

        System.out.println(
                "Student records saved: "
                        + rows.length()
        );
    }
}