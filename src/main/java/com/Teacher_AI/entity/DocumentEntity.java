package com.Teacher_AI.entity;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;

import jakarta.persistence.Table;

@Entity
@Table(name = "documents")
public class DocumentEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer documentId;

    private Integer userId;

    private String fileName;

    @Column(columnDefinition = "TEXT")
    private String filePath;

    private String fileType;

    private Long fileSize;

    private String status;
    
    @Column(columnDefinition = "TEXT")
    private String cloudinaryUrl;

    private String cloudinaryPublicId;

    private Boolean structuredData;

    private String structuredDataType;

    @Column(columnDefinition = "TEXT")
    private String structuredDataJson;
    
    private String cloudinaryResourceType;
    
    @Column(columnDefinition = "TEXT")
    private String extractedText;

    private LocalDateTime createdAt;


    // Document ID
    public Integer getDocumentId() {
        return documentId;
    }

    public void setDocumentId(Integer documentId) {
        this.documentId = documentId;
    }


    // User ID
    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }


    // File Name
    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }


    // File Path
    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }


    // File Type
    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }


    // File Size
    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }


    // Status
    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    

    public String getCloudinaryUrl() {
		return cloudinaryUrl;
	}

	public void setCloudinaryUrl(String cloudinaryUrl) {
		this.cloudinaryUrl = cloudinaryUrl;
	}

	public String getCloudinaryPublicId() {
		return cloudinaryPublicId;
	}

	public void setCloudinaryPublicId(String cloudinaryPublicId) {
		this.cloudinaryPublicId = cloudinaryPublicId;
	}
	
	

	public Boolean getStructuredData() {
		return structuredData;
	}

	public void setStructuredData(Boolean structuredData) {
		this.structuredData = structuredData;
	}

	public String getStructuredDataType() {
		return structuredDataType;
	}

	public void setStructuredDataType(String structuredDataType) {
		this.structuredDataType = structuredDataType;
	}

	public String getStructuredDataJson() {
		return structuredDataJson;
	}

	public void setStructuredDataJson(String structuredDataJson) {
		this.structuredDataJson = structuredDataJson;
	}

	public String getCloudinaryResourceType() {
		return cloudinaryResourceType;
	}

	public void setCloudinaryResourceType(String cloudinaryResourceType) {
		this.cloudinaryResourceType = cloudinaryResourceType;
	}

	// Created At
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    
    
    public String getExtractedText() {
		return extractedText;
	}

	public void setExtractedText(String extractedText) {
		this.extractedText = extractedText;
	}

	public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
    
    
}

