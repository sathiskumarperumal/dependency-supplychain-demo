package com.demo.supplychain;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * Computes order discounts. Several branches here are deliberately left
 * uncovered by the test suite so that JaCoCo reports line coverage below the
 * 80% gate (see Issue #6).
 */
public class DiscountCalculator {

    // Uses the vulnerable log4j-core 2.14.1 dependency (Issue #2).
    private static final Logger LOG = LogManager.getLogger(DiscountCalculator.class);

    public enum CustomerTier { STANDARD, SILVER, GOLD, PLATINUM }

    /**
     * @param amount order subtotal
     * @param tier   customer loyalty tier
     * @return discounted total
     */
    public double applyDiscount(double amount, CustomerTier tier) {
        if (amount < 0) {
            throw new IllegalArgumentException("amount must be non-negative");
        }
        LOG.info("Applying discount for tier={} amount={}", tier, amount);

        double rate = switch (tier) {
            case STANDARD -> 0.0;
            case SILVER -> 0.05;
            case GOLD -> 0.10;
            case PLATINUM -> 0.20;
        };

        double discounted = amount - (amount * rate);
        return applyBulkBonus(amount, discounted);
    }

    /** Extra bonus on large orders — intentionally NOT exercised by tests. */
    private double applyBulkBonus(double amount, double discounted) {
        if (amount >= 10_000) {
            LOG.info("Large order bonus applied");
            return discounted * 0.95;
        }
        if (amount >= 5_000) {
            return discounted * 0.98;
        }
        return discounted;
    }

    /** Loyalty points — intentionally NOT exercised by tests. */
    public int loyaltyPoints(double amount, CustomerTier tier) {
        int base = (int) (amount / 100);
        return switch (tier) {
            case STANDARD -> base;
            case SILVER -> base * 2;
            case GOLD -> base * 3;
            case PLATINUM -> base * 5;
        };
    }
}
