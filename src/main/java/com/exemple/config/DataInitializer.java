package com.exemple.config;

import com.exemple.model.Product;
import com.exemple.repository.ProductRepository;
import com.exemple.repository.AlternativeRepository;
import com.exemple.model.Alternative;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DataInitializer {

    @Autowired
    private ProductRepository productRepository;

    @Autowired
    private AlternativeRepository alternativeRepository;

    @Bean
    public ApplicationRunner initializeData() {
        return args -> {
            // إزالة البيانات القديمة
            if (productRepository.count() == 0) {
                // منتجات مقاطعة عالمية
                Product cocaCola = new Product(null, "كوكا كولا", "مشروب غازي", "المشروبات", "Coca-Cola", "5449000000036", true, 
                    "شركة تدعم الاحتلال الإسرائيلي", false, null, 2.5, "مشروب غازي");
                
                Product nestle = new Product(null, "نسكافيه", "قهوة سريعة الذوبان", "القهوة", "Nescafé", "7613034728899", true,
                    "منتجات نستله تدعم الاحتلال", false, null, 5.0, "قهوة سريعة الذوبان");

                Product starbucks = new Product(null, "منتجات ستاربكس", "قهوة وحلويات", "المقاهي", "Starbucks", null, true,
                    "ستاربكس تدعم سياسات الاحتلال", false, null, 6.0, "منتجات القهوة والحلويات");

                // منتجات تونسية آمنة
                Product cafeTunisien = new Product(null, "قهوة الهلال التونسية", "قهوة محلية الصنع", "القهوة", "الهلال", "9876543210", false,
                    null, true, null, 3.5, "قهوة تونسية عالية الجودة");

                Product jusOrange = new Product(null, "عصير البرتقال التونسي", "عصير طازج", "المشروبات", "الصفاقسي", "1234567890", false,
                    null, true, null, 2.0, "عصير برتقال من ولاية صفاقس");

                Product dateTunisia = new Product(null, "تمر التمرة", "تمر جاف", "الحلويات", "التمرة التونسية", "5555555555", false,
                    null, true, null, 15.0, "تمر تونسي من واحات الساحل");

                Product harissaTunisia = new Product(null, "حريسة تونسية", "معجون حار", "التوابل", "الأم علياء", "3333333333", false,
                    null, true, null, 4.5, "حريسة تقليدية تونسية");

                Product mlouhiaTunisia = new Product(null, "ملوحية تونسية", "حبوب كاملة", "الحبوب", "الحقل التونسي", "4444444444", false,
                    null, true, null, 8.0, "ملوحية من المناطق الشمالية");

                // حفظ المنتجات
                productRepository.save(cocaCola);
                productRepository.save(nestle);
                productRepository.save(starbucks);
                productRepository.save(cafeTunisien);
                productRepository.save(jusOrange);
                productRepository.save(dateTunisia);
                productRepository.save(harissaTunisia);
                productRepository.save(mlouhiaTunisia);

                // إضافة البدائل
                Alternative alt1 = new Alternative(null, cocaCola, jusOrange, "عصير تونسي بديل صحي", 0.85);
                Alternative alt2 = new Alternative(null, nestle, cafeTunisien, "قهوة تونسية الصنع", 0.90);
                Alternative alt3 = new Alternative(null, starbucks, cafeTunisien, "قهوة تونسية عالية الجودة", 0.88);
                Alternative alt4 = new Alternative(null, cocaCola, dateTunisia, "حلويات صحية تونسية", 0.75);

                alternativeRepository.save(alt1);
                alternativeRepository.save(alt2);
                alternativeRepository.save(alt3);
                alternativeRepository.save(alt4);

                System.out.println("✅ تم تحميل البيانات الأولية بنجاح!");
            }
        };
    }
}
