package com.consumesafe.service;

import com.consumesafe.entity.Product;
import com.consumesafe.repository.ProductRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class ProductServiceTest {

    @Mock
    private ProductRepository productRepository;

    @InjectMocks
    private ProductService productService;

    private Product testProduct;
    private Product boycottedProduct;
    private Product tunisianProduct;

    @BeforeEach
    void setUp() {
        // Produit test standard
        testProduct = Product.builder()
                .id(1L)
                .name("Test Product")
                .description("Test Description")
                .category("Food")
                .brand("Test Brand")
                .barcode("123456789")
                .boycotted(false)
                .boycottReason(null)
                .imageUrl("test.jpg")
                .tunisian(false)
                .price(10.99)
                .build();

        // Produit boycotté
        boycottedProduct = Product.builder()
                .id(2L)
                .name("Boycotted Product")
                .description("Boycotted Description")
                .category("Beverage")
                .brand("Boycott Brand")
                .barcode("987654321")
                .boycotted(true)
                .boycottReason("Political reasons")
                .imageUrl("boycott.jpg")
                .tunisian(false)
                .price(15.99)
                .build();

        // Produit tunisien
        tunisianProduct = Product.builder()
                .id(3L)
                .name("Tunisian Product")
                .description("Made in Tunisia")
                .category("Food")
                .brand("Tunisian Brand")
                .barcode("555555555")
                .boycotted(false)
                .boycottReason(null)
                .imageUrl("tunisian.jpg")
                .tunisian(true)
                .price(8.99)
                .build();
    }

    @Test
    void testFindByName_ProductExists() {
        // Given
        when(productRepository.findByName("Test Product"))
                .thenReturn(Optional.of(testProduct));

        // When
        Optional<Product> result = productService.findByName("Test Product");

        // Then
        assertTrue(result.isPresent());
        assertEquals("Test Product", result.get().getName());
        verify(productRepository, times(1)).findByName("Test Product");
    }

    @Test
    void testFindByName_ProductNotFound() {
        // Given
        when(productRepository.findByName("Nonexistent"))
                .thenReturn(Optional.empty());

        // When
        Optional<Product> result = productService.findByName("Nonexistent");

        // Then
        assertFalse(result.isPresent());
        verify(productRepository, times(1)).findByName("Nonexistent");
    }

    @Test
    void testIsBoycotted_ProductIsBoycotted() {
        // Given
        when(productRepository.findByName("Boycotted Product"))
                .thenReturn(Optional.of(boycottedProduct));

        // When
        boolean result = productService.isBoycotted("Boycotted Product");

        // Then
        assertTrue(result);
    }

    @Test
    void testIsBoycotted_ProductNotBoycotted() {
        // Given
        when(productRepository.findByName("Test Product"))
                .thenReturn(Optional.of(testProduct));

        // When
        boolean result = productService.isBoycotted("Test Product");

        // Then
        assertFalse(result);
    }

    @Test
    void testIsBoycotted_ProductNotFound() {
        // Given
        when(productRepository.findByName("Nonexistent"))
                .thenReturn(Optional.empty());

        // When
        boolean result = productService.isBoycotted("Nonexistent");

        // Then
        assertFalse(result);
    }

    @Test
    void testGetBoycottReason_ProductExists() {
        // Given
        when(productRepository.findByName("Boycotted Product"))
                .thenReturn(Optional.of(boycottedProduct));

        // When
        String reason = productService.getBoycottReason("Boycotted Product");

        // Then
        assertEquals("Political reasons", reason);
    }

    @Test
    void testGetBoycottReason_ProductNotFound() {
        // Given
        when(productRepository.findByName("Nonexistent"))
                .thenReturn(Optional.empty());

        // When
        String reason = productService.getBoycottReason("Nonexistent");

        // Then
        assertNull(reason);
    }

    @Test
    void testGetTunisianAlternatives() {
        // Given
        List<Product> tunisianProducts = Arrays.asList(tunisianProduct);
        when(productRepository.findByTunisianTrue())
                .thenReturn(tunisianProducts);

        // When
        List<Product> result = productService.getTunisianAlternatives();

        // Then
        assertEquals(1, result.size());
        assertTrue(result.get(0).getTunisian());
        verify(productRepository, times(1)).findByTunisianTrue();
    }

    @Test
    void testGetTunisianAlternativesByCategory() {
        // Given
        List<Product> tunisianFoodProducts = Arrays.asList(tunisianProduct);
        when(productRepository.findTunisianByCategory("Food"))
                .thenReturn(tunisianFoodProducts);

        // When
        List<Product> result = productService.getTunisianAlternativesByCategory("Food");

        // Then
        assertEquals(1, result.size());
        assertEquals("Food", result.get(0).getCategory());
        assertTrue(result.get(0).getTunisian());
    }

    @Test
    void testGetBoycottedProducts() {
        // Given
        List<Product> boycottedProducts = Arrays.asList(boycottedProduct);
        when(productRepository.findByBoycottedTrue())
                .thenReturn(boycottedProducts);

        // When
        List<Product> result = productService.getBoycottedProducts();

        // Then
        assertEquals(1, result.size());
        assertTrue(result.get(0).getBoycotted());
        verify(productRepository, times(1)).findByBoycottedTrue();
    }

    @Test
    void testSearchProducts() {
        // Given
        String query = "test";
        List<Product> searchResults = Arrays.asList(testProduct);
        when(productRepository.searchProducts(query))
                .thenReturn(searchResults);

        // When
        List<Product> result = productService.searchProducts(query);

        // Then
        assertEquals(1, result.size());
        assertTrue(result.get(0).getName().contains("Test"));
        verify(productRepository, times(1)).searchProducts(query);
    }

    @Test
    @Transactional
    void testSaveProduct() {
        // Given
        when(productRepository.save(any(Product.class)))
                .thenReturn(testProduct);

        // When
        Product savedProduct = productService.saveProduct(testProduct);

        // Then
        assertNotNull(savedProduct);
        assertEquals(testProduct.getName(), savedProduct.getName());
        verify(productRepository, times(1)).save(testProduct);
    }

    @Test
    @Transactional
    void testDeleteProduct() {
        // Given
        Long productId = 1L;
        doNothing().when(productRepository).deleteById(productId);

        // When
        productService.deleteProduct(productId);

        // Then
        verify(productRepository, times(1)).deleteById(productId);
    }

    @Test
    void testGetAllProducts() {
        // Given
        List<Product> allProducts = Arrays.asList(testProduct, boycottedProduct, tunisianProduct);
        when(productRepository.findAll())
                .thenReturn(allProducts);

        // When
        List<Product> result = productService.getAllProducts();

        // Then
        assertEquals(3, result.size());
        verify(productRepository, times(1)).findAll();
    }

    @Test
    void testGetProductById_Exists() {
        // Given
        Long productId = 1L;
        when(productRepository.findById(productId))
                .thenReturn(Optional.of(testProduct));

        // When
        Optional<Product> result = productService.getProductById(productId);

        // Then
        assertTrue(result.isPresent());
        assertEquals(productId, result.get().getId());
    }

    @Test
    void testGetProductById_NotFound() {
        // Given
        Long productId = 999L;
        when(productRepository.findById(productId))
                .thenReturn(Optional.empty());

        // When
        Optional<Product> result = productService.getProductById(productId);

        // Then
        assertFalse(result.isPresent());
    }

    @Test
    void testProductExists_True() {
        // Given
        when(productRepository.existsByName("Test Product"))
                .thenReturn(true);

        // When
        boolean exists = productService.productExists("Test Product");

        // Then
        assertTrue(exists);
    }

    @Test
    void testProductExists_False() {
        // Given
        when(productRepository.existsByName("Nonexistent"))
                .thenReturn(false);

        // When
        boolean exists = productService.productExists("Nonexistent");

        // Then
        assertFalse(exists);
    }

    @Test
    void testGetTunisianAlternatives_EmptyList() {
        // Given
        when(productRepository.findByTunisianTrue())
                .thenReturn(Collections.emptyList());

        // When
        List<Product> result = productService.getTunisianAlternatives();

        // Then
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }

    @Test
    void testSearchProducts_EmptyResult() {
        // Given
        String query = "nonexistent";
        when(productRepository.searchProducts(query))
                .thenReturn(Collections.emptyList());

        // When
        List<Product> result = productService.searchProducts(query);

        // Then
        assertNotNull(result);
        assertTrue(result.isEmpty());
    }
}