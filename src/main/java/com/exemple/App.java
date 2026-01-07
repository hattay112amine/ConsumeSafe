package com.exemple;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = {"com.exemple"})
public class App {
    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
        System.out.println("\n" +
            "╔════════════════════════════════════════════════════════════╗\n" +
            "║          🛡️ ConsumeSafe Application Started 🛡️            ║\n" +
            "║     حماية المستهلك والمنتجات التونسية - Tunisie First    ║\n" +
            "╠════════════════════════════════════════════════════════════╣\n" +
            "║  🌐 Web Interface:  http://localhost:8082                  ║\n" +
            "║  📡 API Endpoint:   http://localhost:8082/api/products   ║\n" +
            "║  💾 Database:       MySQL ConsumeSafe                      ║\n" +
            "╚════════════════════════════════════════════════════════════╝\n");
    }
}
