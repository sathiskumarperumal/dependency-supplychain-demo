package com.demo.supplychain;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Thin test suite — covers only the STANDARD/GOLD branches of
 * {@link DiscountCalculator#applyDiscount}. The bulk-bonus branches and the
 * entire loyaltyPoints method are left untested on purpose so that JaCoCo
 * line coverage stays under the 80% gate (Issue #6).
 */
class DiscountCalculatorTest {

    private final DiscountCalculator calc = new DiscountCalculator();

    @Test
    void standardTierGetsNoDiscount() {
        assertEquals(100.0, calc.applyDiscount(100.0, DiscountCalculator.CustomerTier.STANDARD), 0.001);
    }

    @Test
    void goldTierGetsTenPercentOff() {
        assertEquals(90.0, calc.applyDiscount(100.0, DiscountCalculator.CustomerTier.GOLD), 0.001);
    }
}
