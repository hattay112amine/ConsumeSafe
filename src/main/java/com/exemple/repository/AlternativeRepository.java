package com.exemple.repository;

import com.exemple.model.Alternative;
import com.exemple.model.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface AlternativeRepository extends JpaRepository<Alternative, Long> {
    List<Alternative> findByBoycottedProduct(Product boycottedProduct);
    List<Alternative> findByBoycottedProductOrderBySimilarityScoreDesc(Product boycottedProduct);
}
