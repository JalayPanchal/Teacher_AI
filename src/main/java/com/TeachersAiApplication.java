package com;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication(scanBasePackages = "com.Teacher_AI")
public class TeachersAiApplication {

    public static void main(String[] args) {
        SpringApplication.run(TeachersAiApplication.class, args);
    }
}