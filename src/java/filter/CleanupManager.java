/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package filter;

/**
 *
 * @author ACER
 */

import service.OrderService;

public class CleanupManager {
    private static long lastRunTime = 0;
    private static final long INTERVAL = 30 * 60 * 1000; // 30 phút

    public static synchronized void runCleanupIfNeeded() {
        long now = System.currentTimeMillis();
        if (now - lastRunTime > INTERVAL) {
            OrderService oService = new OrderService();
            oService.deletePendingOrdersOlderThan(1);
            lastRunTime = now;
            System.out.println("Cleanup ran at " + new java.util.Date());
        }
    }
}
