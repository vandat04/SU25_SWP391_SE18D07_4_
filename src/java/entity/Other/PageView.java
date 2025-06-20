/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.Other;

import java.sql.Timestamp;
import java.time.LocalDateTime;

/**
 *
 * @author ACER
 */
public class PageView {
    private int viewID;
    private String pageUrl;
    private Integer userID;
    private String ipAddress;
    private String userAgent;
    private String referrer;
    private String sessionID;
    private Timestamp viewDate;

    // Constructors-------------------------------------------------------------
    public PageView() {}

    
    //--------------------------------------------------------------------------
    public int getViewID() {
        return viewID;
    }

    public void setViewID(int viewID) {
        this.viewID = viewID;
    }

    public String getPageUrl() {
        return pageUrl;
    }

    public void setPageUrl(String pageUrl) {
        this.pageUrl = pageUrl;
    }

    public Integer getUserID() {
        return userID;
    }

    public void setUserID(Integer userID) {
        this.userID = userID;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public String getReferrer() {
        return referrer;
    }

    public void setReferrer(String referrer) {
        this.referrer = referrer;
    }

    public String getSessionID() {
        return sessionID;
    }

    public void setSessionID(String sessionID) {
        this.sessionID = sessionID;
    }

    public Timestamp getViewDate() {
        return viewDate;
    }

    public void setViewDate(Timestamp viewDate) {
        this.viewDate = viewDate;
    }

    @Override
    public String toString() {
        return "PageView{" + "viewID=" + viewID + ", pageUrl=" + pageUrl + ", userID=" + userID + ", ipAddress=" + ipAddress + ", userAgent=" + userAgent + ", referrer=" + referrer + ", sessionID=" + sessionID + ", viewDate=" + viewDate + '}';
    }
    
}
