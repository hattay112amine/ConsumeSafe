package com.exemple.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "products")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;

    @Column(length = 500)
    private String description;

    @Column(nullable = false)
    private String category;

    private String brand;

    private String barcode;

    @Column(nullable = false)
    private boolean boycotted;

    @Column(length = 500)
    private String boycottReason;

    @Column(nullable = false)
    private boolean tunisian;

    private String imageUrl;

    private Double price;

    @Column(length = 1000)
    private String details;
}
