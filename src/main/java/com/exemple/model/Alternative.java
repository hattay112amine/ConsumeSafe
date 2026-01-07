package com.exemple.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "alternatives")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Alternative {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "boycotted_product_id")
    private Product boycottedProduct;

    @ManyToOne
    @JoinColumn(name = "alternative_product_id")
    private Product alternativeProduct;

    @Column(length = 500)
    private String reason;

    private Double similarityScore;
}
