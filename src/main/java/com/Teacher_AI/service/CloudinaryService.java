package com.Teacher_AI.service;

import java.io.IOException;
import java.util.Map;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;

@Service
public class CloudinaryService {

    private final Cloudinary cloudinary;

    public CloudinaryService(Cloudinary cloudinary) {
        this.cloudinary = cloudinary;
    }

    public Map<String, Object> uploadFile(
            MultipartFile file,
            Integer userId) throws IOException {

        String publicId =
                "teachers/" +
                userId +
                "/" +
                UUID.randomUUID();

        Map<String, Object> options = ObjectUtils.asMap(
                "public_id", publicId,
                "resource_type", "auto",
                "use_filename", false
        );

        return cloudinary.uploader().upload(
                file.getBytes(),
                options
        );
    }

    public void deleteFile(
            String publicId,
            String resourceType) throws IOException {

        cloudinary.uploader().destroy(
                publicId,
                ObjectUtils.asMap(
                        "resource_type", resourceType,
                        "type", "upload"
                )
        );
    }
}