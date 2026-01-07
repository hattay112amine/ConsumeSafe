package com.consumesafe.service;

import com.consumesafe.entity.Product;
import com.consumesafe.repository.ProductRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class ProductServiceIntegrationTest {

    @Autowired
    private ProductService productService;

    @Autowired
    private ProductRepository productRepository;

    @Test
    void testSaveAndRetrieveProduct() {
        // Given
        Product product = Product.builder()
                .name("Integration Test Product")
                .description("Integration Test")
                .category("Test")
                .boycotted(false)
                .tunisian(true)
                .price(9.99)
                .build();

        // When
        Product saved = productService.saveProduct(product);
        Product retrieved = productService.getProductById(saved.getId()).orElse(null);

        // Then
        assertThat(retrieved).isNotNull();
        assertThat(retrieved.getName()).isEqualTo("Integration Test Product");
        assertThat(retrieved.getTunisian()).isTrue();
    }

    @Test
    void testTunisianAlternativesIntegration() {
        // Given
        Product tunisian1 = Product.builder()
                .name("Tunisian 1")
                .tunisian(true)
                .build();
        
        Product tunisian2 = Product.builder()
                .name("Tunisian 2")
                .tunisian(true)
                .build();
        
        Product nonTunisian = Product.builder()
                .name("Non Tunisian")
                .tunisian(false)
                .build();

        productRepository.save(tunisian1);
        productRepository.save(tunisian2);
        productRepository.save(nonTunisian);

        // When
        List<Product> tunisianProducts = productService.getTunisianAlternatives();

        // Then
        assertThat(tunisianProducts).hasSize(2);
        assertThat(tunisianProducts)
                .extracting(Product::getName)
                .containsExactlyInAnyOrder("Tunisian 1", "Tunisian 2");
    }
}