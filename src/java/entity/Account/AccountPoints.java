/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity.Account;

/**
 *
 * @author ACER
 */
public class AccountPoints {
    private int pointsID;
    private int userID;
    private int points;

    public AccountPoints(int pointsID, int userID, int points) {
        this.pointsID = pointsID;
        this.userID = userID;
        this.points = points;
    }
    
    public AccountPoints(int userID, int points) {
        this.userID = userID;
        this.points = points;
    }

    public AccountPoints() {
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public int getPointsID() {
        return pointsID;
    }

    public void setPointsID(int pointsID) {
        this.pointsID = pointsID;
    }

    @Override
    public String toString() {
        return "AccountPoints{" + "pointsID=" + pointsID + ", userID=" + userID + ", points=" + points + '}';
    }

}
