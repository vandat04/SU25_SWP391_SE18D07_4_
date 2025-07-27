/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import context.DBContext;
import entity.CraftVillage.CraftType;
import entity.Ticket.Ticket;
import entity.Ticket.TicketType;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.Types;

/**
 *
 * @author ACER
 */
public class TicketDAO {

    private static final Logger LOGGER = Logger.getLogger(TicketDAO.class.getName());

    private TicketType mapResultSetToTicketType(ResultSet rs) throws SQLException {
        return new TicketType(
                rs.getInt("typeID"),
                rs.getString("typeName"),
                rs.getString("description"),
                rs.getString("ageRange"),
                rs.getInt("status"),
                rs.getTimestamp("createdDate"),
                rs.getTimestamp("updatedDate")
        );
    }

    private Ticket mapResultSetToTicket(ResultSet rs) throws SQLException {
        return new Ticket(
                rs.getInt("ticketID"),
                rs.getInt("villageID"),
                rs.getInt("typeID"),
                rs.getBigDecimal("price"),
                rs.getInt("status"),
                rs.getTimestamp("createdDate"),
                rs.getTimestamp("updatedDate")
        );
    }

    private void closeResources(java.sql.Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
        }
    }

    public List<TicketType> getAllTicketType() {
        List<TicketType> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = new DBContext().getConnection();
            // Query cho user - chỉ lấy sản phẩm active của seller
            String sql = "SELECT * FROM TicketType WHERE status = 1";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToTicketType(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return list;
    }

    public boolean createTicketByAdmin(Ticket ticket) {
        String query = "{? = CALL AddTicketByAdmin(?, ?, ?, ?)}";
        Connection conn = null;
        CallableStatement cs = null;
        try {
            conn = new DBContext().getConnection();
            cs = conn.prepareCall(query);
            cs.registerOutParameter(1, java.sql.Types.INTEGER);
            cs.setInt(2, ticket.getVillageID());
            cs.setInt(3, ticket.getTypeID());
            cs.setBigDecimal(4, ticket.getPrice());
            cs.setInt(5, ticket.getStatus());

            cs.execute();

            int result = cs.getInt(1);
            LOGGER.log(Level.INFO, "AddTicketByAdmin result code: {0}", result);

            return result == 1;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating ticket with villageID: "
                    + ticket.getVillageID() + ", typeID: " + ticket.getTypeID(), e);
        } finally {
            closeResources(conn, cs, null);
        }
        return false;
    }

    public boolean updateTicketByAdmin(Ticket ticket) {
        String sql = "{? = CALL UpdateTicketByAdmin(?, ?, ?)}";
        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {

            cs.registerOutParameter(1, Types.INTEGER);

            cs.setInt(2, ticket.getTicketID());
            cs.setBigDecimal(3, ticket.getPrice());
            cs.setInt(4, ticket.getStatus());

            cs.execute();

            int result = cs.getInt(1);
            return result == 1;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating ticket: " + e.getMessage(), e);
        }
        return false;
    }

    public boolean deleteTicketByAdmin(int ticketID) {
        String sql = "{? = CALL DeleteTicketByAdmin(?)}";
        try (Connection con = DBContext.getConnection(); CallableStatement cs = con.prepareCall(sql)) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setInt(2, ticketID);
            // Output parameter
            cs.execute();
            if (cs.getInt(1) == 1) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Ticket> getTickeReportByAdmin(int status) {
        String query;
        List<Ticket> list = new ArrayList<>();
        if (status == 0) {
            query = "SELECT * FROM VillageTicket WHERE status = 0";
        } else if (status == 1) {
            query = "SELECT * FROM VillageTicket WHERE status = 1";
        } else {
            query = "SELECT * FROM VillageTicket WHERE status = 1 ORDER BY typeID ASC";
        }
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTicket(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Ghi log tốt hơn
        }
        return list;
    }

    public String getTicketNameByID(int typeID) {
        String query = "SELECT typeName FROM TicketType WHERE status = 1 AND typeID = ?";

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, typeID);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("typeName");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting ticket type name for typeID: " + typeID, e);
        }
        return null;
    }

    public List<Ticket> getTicketsByVillage(int villageId) {
        List<Ticket> list = new ArrayList<>();
        String query = "SELECT * FROM VillageTicket WHERE  villageID = ? and status = 1";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, villageId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTicket(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // hoặc log ra file log
        }
        return list;
    }

    public static void main(String[] args) {
        System.out.println(new TicketDAO().searchTicketByAdmin(1, 0, "2", 0, 10).size());
    }

    public List<Ticket> searchTicketByAdmin(int status, int searchID, String contentSearch) {
        List<Ticket> list = new ArrayList<>();
        String query;
        boolean hasContent = false;

        switch (searchID) {
            case 1: // Tìm kiếm villageID
                query = "SELECT * FROM VillageTicket WHERE status = ? AND villageID LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                hasContent = true;
                break;
            case 2: // Sắp xếp theo villageID tăng
                query = "SELECT * FROM VillageTicket WHERE status = ? ORDER BY villageID ASC";
                break;
            case 3: // Tìm kiếm typeID
                query = "SELECT * FROM VillageTicket WHERE status = ? AND typeID LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                hasContent = true;
                break;
            case 4: // Sắp xếp theo typeID tăng
                query = "SELECT * FROM VillageTicket WHERE status = ? ORDER BY typeID ASC";
                break;
            case 5: // Giá tăng
                query = "SELECT * FROM VillageTicket WHERE status = ? ORDER BY price ASC";
                break;
            case 6: // Giá giảm
                query = "SELECT * FROM VillageTicket WHERE status = ? ORDER BY price DESC";
                break;
            case 7: // Ngày tạo tăng
                query = "SELECT * FROM VillageTicket WHERE status = ? ORDER BY createdDate ASC";
                break;
            case 8: // Ngày tạo giảm
                query = "SELECT * FROM VillageTicket WHERE status = ? ORDER BY createdDate DESC";
                break;
            default: // Mặc định lọc theo status
                query = "SELECT * FROM VillageTicket WHERE status = ?";
                break;
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, status);
            if (hasContent) {
                ps.setString(2, contentSearch);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToTicket(rs));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<Ticket> searchTicketByAdmin(int status, int searchID, String contentSearch, int offset, int pageSize) {
        List<Ticket> list = new ArrayList<>();
        String query = "";
        boolean hasContent = false;
        boolean hasPagination = true;

        switch (searchID) {
            case 1: // search by villageID
                query = "SELECT * FROM VillageTicket WHERE status = ? AND villageID LIKE ? ORDER BY villageID ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                contentSearch = "%" + contentSearch + "%";
                hasContent = true;
                break;

            case 2: // sort by villageID
                query = "SELECT * FROM VillageTicket WHERE status = ? ORDER BY villageID ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                break;

            case 3: // search by typeID
                query = "SELECT * FROM VillageTicket WHERE status = ? AND typeID LIKE ? ORDER BY typeID ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                contentSearch = "%" + contentSearch + "%";
                hasContent = true;
                break;

            case 4: // sort by typeID
                query = "SELECT * FROM VillageTicket WHERE status = ? ORDER BY typeID ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                break;

            case 5: // sort by price ASC
                query = "SELECT * FROM VillageTicket WHERE status = ? ORDER BY price ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                break;

            case 6: // sort by price DESC
                query = "SELECT * FROM VillageTicket WHERE status = ? ORDER BY price DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                break;

            case 7: // sort by createdDate ASC
                query = "SELECT * FROM VillageTicket WHERE status = ? ORDER BY createdDate ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                break;

            case 8: // sort by createdDate DESC
                query = "SELECT * FROM VillageTicket WHERE status = ? ORDER BY createdDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                break;

            default:
                query = "SELECT * FROM VillageTicket WHERE status = ? ORDER BY ticketID ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
                break;
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, status);
            int paramIndex = 2;

            if (hasContent) {
                ps.setString(paramIndex++, contentSearch);
            }

            ps.setInt(paramIndex++, offset);     // OFFSET ? ROWS
            ps.setInt(paramIndex, pageSize);     // FETCH NEXT ? ROWS ONLY

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToTicket(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countTotalTicketByAdmin(int status, int searchID, String contentSearch) {
        int count = 0;
        String query;
        boolean hasContent = false;

        switch (searchID) {
            case 1:
                query = "SELECT COUNT(*) FROM VillageTicket WHERE status = ? AND villageID LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                hasContent = true;
                break;
            case 3:
                query = "SELECT COUNT(*) FROM VillageTicket WHERE status = ? AND typeID LIKE ?";
                contentSearch = "%" + contentSearch + "%";
                hasContent = true;
                break;
            default:
                query = "SELECT COUNT(*) FROM VillageTicket WHERE status = ?";
                break;
        }

        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, status);
            if (hasContent) {
                ps.setString(2, contentSearch);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }

    public int getVillageIDByTicketID(int ticketId) {
        String query = "SELECT villageID FROM VillageTicket WHERE ticketID = ?";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, ticketId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("villageID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên dùng logging thay vì printStackTrace trong production
        }
        return 0;
    }

    public Ticket getTicketByTicketId(int ticketId) {
        String query = "SELECT * FROM VillageTicket WHERE ticketID = ? and status = 1";
        try (Connection conn = DBContext.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, ticketId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToTicket(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace(); // Nên dùng logging thay vì printStackTrace trong production
        }
        return null;
    }
}
