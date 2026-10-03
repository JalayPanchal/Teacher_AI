package com.Teacher_AI.service;

import java.util.Optional;

import org.springframework.stereotype.Service;

import com.Teacher_AI.entity.UserEntity;
import com.Teacher_AI.repository.UserRepository;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // Signup
    public UserEntity createUser(UserEntity user) {

        user.setRole("TEACHER");
        user.setActive(true);

        return userRepository.save(user);
    }

    // Login
    public UserEntity loginUser(String email, String password) {

        Optional<UserEntity> optionalUser = userRepository.findByEmail(email);

        if (optionalUser.isEmpty()) {
            return null;
        }

        UserEntity user = optionalUser.get();

        if (!user.isActive()) {
            return null;
        }

        if (!user.getPassword().equals(password)) {
            return null;
        }

        return user;
    }
}