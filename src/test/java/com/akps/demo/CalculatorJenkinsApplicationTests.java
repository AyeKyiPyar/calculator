package com.akps.demo;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
class CalculatorJenkinsApplicationTests {

	@Test
	void contextLoads() {
		System.out.println("Test starting.....");
	}

}
