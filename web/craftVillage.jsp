<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="en" class="no-js">
    <head>
        <meta charset="utf-8">
        <title>Craft Villages - Da Nang Craft Village</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">

        <!-- Fonts -->
        <link href="https://fonts.googleapis.com/css?family=Cairo:400,600,700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Poppins:600&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Playfair+Display:400i,700i" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Ubuntu&display=swap" rel="stylesheet">

        <!-- Favicon -->
        <link rel="shortcut icon" type="image/x-icon" href="hinhanh/Logo/cropped-Favicon-1-32x32.png" />

        <!-- YOUR THEME CSS -->
        <link rel="stylesheet" href="assets/css/bootstrap.min.css">
        <link rel="stylesheet" href="assets/css/animate.min.css">
        <link rel="stylesheet" href="assets/css/font-awesome.min.css">
        <link rel="stylesheet" href="assets/css/nice-select.css">
        <link rel="stylesheet" href="assets/css/slick.min.css">
        <!-- Select2 CSS for searchable dropdown -->
        <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
        <link rel="stylesheet" href="assets/css/style.css">
        <link rel="stylesheet" href="assets/css/main-color03-green.css">

        <!-- Custom CSS -->
        <style>
            /* CSS for Select2 (Kept from original) */
            .select2-container--default .select2-selection--single {
                border-radius: 20px !important;
                height: 40px !important;
                padding-top: 4px;
            }
            .select2-container--open .select2-dropdown--below,
            .select2-container--open .select2-dropdown--above {
                border-radius: 15px !important;
            }
            .wrap-selectors {
                display: flex;
                flex-direction: column;
                gap: 20px;
            }

            /* ==========================================================================
               NEW & IMPROVED CSS FOR VILLAGE LIST
               ========================================================================== */

            /* --- Village Card Container --- */
            .village-card {
                background-color: #fff;
                border: 1px solid #e9ecef; /* Subtle border */
                border-radius: 15px;      /* Softer corners */
                box-shadow: 0 4px 12px rgba(0,0,0,0.06); /* Soft, modern shadow */
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                overflow: hidden;
                display: flex;
                flex-direction: column;
                height: 100%; /* CRITICAL: Ensures all cards in a row are the same height */
            }

            /* --- Card Hover Effect --- */
            .village-card:hover {
                transform: translateY(-8px); /* Lifts the card up */
                box-shadow: 0 10px 25px rgba(0,0,0,0.1); /* Deeper shadow for emphasis */
            }

            /* --- Image Wrapper & Image --- */
            .village-card-img-wrapper {
                height: 220px; /* Fixed height for all images */
                overflow: hidden; /* Hides the part of image that overflows on zoom */
            }
            
            .village-card-img {
                width: 100%;
                height: 100%;
                object-fit: cover; /* Ensures image covers the area without distortion */
                transition: transform 0.4s ease; /* Smooth zoom transition */
            }

            .village-card:hover .village-card-img {
                transform: scale(1.05); /* Subtle zoom effect on hover */
            }

            /* --- Card Body & Content --- */
            .village-card .card-body {
                padding: 20px;
                display: flex;
                flex-direction: column;
                flex-grow: 1; /* Allows body to expand and push button down */
            }

            .village-card .card-title {
                font-family: 'Poppins', sans-serif;
                font-size: 1.2rem;
                font-weight: 600;
                color: #34495e; /* A softer, more professional color */
                margin-bottom: 15px;
            }
            
            /* --- Button Styling --- */
            .village-card .btn {
                margin-top: auto; /* CRITICAL: Pushes button to the bottom */
                border-radius: 50px; /* Pill-shaped button */
                padding: 10px 25px;
                font-weight: 600;
                transition: background-color 0.3s ease;
            }

            .btn-orange {
                background-color: #e5a134;
                color: #fff;
                border: none;
            }

            .btn-orange:hover {
                background-color: #d48f2e;
                color: #fff;
            }
            
            /* --- "No Results" Message --- */
            .no-results-message {
                text-align: center;
                padding: 50px 20px;
                background-color: #fff;
                border-radius: 15px;
                border: 1px solid #e9ecef;
                box-shadow: 0 4px 12px rgba(0,0,0,0.06);
            }
            .no-results-message p {
                font-size: 1.1rem;
                color: #555;
                margin: 0;
            }
        </style>
    </head>

    <body class="biolife-body">
        <!-- HEADER/MENU -->
        <jsp:include page="Menu.jsp"/>

        <div class="page-contain" style="padding: 60px 0; background: #f9f9f9; margin-top: 30px;">
            <div class="container">
                <div class="row">
                    <!-- Sidebar filters (Unchanged) -->
                    <div class="col-12 col-md-3">
                        <div class="top-functions-area">
                            <div class="flt-item to-left group-on-mobile">
                                <span class="flt-title">Refine</span>
                                <a href="#" class="icon-for-mobile">
                                    <span></span>
                                    <span></span>
                                    <span></span>
                                </a>
                                <div class="wrap-selectors">
                                    <!-- Filter by Village Type -->
                                    <div class="selector-item">
                                        <label for="village-type-filter" style="font-weight: bold; margin-bottom: 8px; display: block;">Filter by village type</label>
                                        <select name="typeID" id="village-type-filter">
                                            <option value="">All village types</option>
                                            <c:forEach items="${listVillages}" var="village">
                                                <option value="${village.typeID}" ${village.typeID == param.typeID ? 'selected' : ''}>
                                                    ${village.typeName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <!-- Filter by Province -->
                                    <div class="selector-item">
                                        <label for="province-filter" style="font-weight: bold; margin-bottom: 8px; display: block;">Filter by Province</label>
                                        <select name="provinceCode" id="province-filter">
                                            <option value="">All provinces</option>
                                            <c:forEach items="${listProvinces}" var="province">
                                                <option value="${province.name}" ${province.name == param.provinceCode ? 'selected' : ''}>
                                                    ${province.name}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Content listing (Unchanged) -->
                    <div class="col-12 col-md-9">
                        <%-- Tiêu đề riêng --%>
                        <div class="section-title text-center mb-5 pb-3 border-bottom border-secondary">
                            <span class="subtitle d-block fs-6 text-secondary mb-2">All Craft Villages</span>
                            <h3 class="main-title fs-4 text-dark fw-bold">Traditional Handicraft Villages</h3>
                        </div>

                        <%-- Danh sách village (UPDATED HTML STRUCTURE) --%>
                        <div class="row">
                            <c:if test="${not empty vlist}">
                                <c:forEach items="${vlist}" var="v">
                                    <div class="col-12 col-sm-6 col-lg-4 mb-4 " style="margin-top: 20px">
                                        <div class="village-card">
                                            <div class="village-card-img-wrapper">
                                                <img src="${v.mainImageUrl}" class="village-card-img" alt="${v.villageName}">
                                            </div>
                                            <div class="card-body">
                                                <h5 class="card-title">${v.villageName}</h5>
                                                <a href="village?id=${v.villageID}" class="btn btn-orange">View Detail</a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:if>

                            <%-- Handle the case where no villages are found (UPDATED) --%>
                            <c:if test="${empty vlist}">
                                <div class="col-12">
                                    <div class="no-results-message">
                                        <p>No craft villages were found that match your filter criteria.</p>
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- FOOTER -->
        <jsp:include page="Footer.jsp"/>

        <!-- Scripts -->
        <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
        <script src="assets/js/bootstrap.min.js"></script>
        <script src="assets/js/jquery.countdown.min.js"></script>
        <script src="assets/js/jquery.nice-select.min.js"></script>
        <script src="assets/js/jquery.nicescroll.min.js"></script>
        <script src="assets/js/slick.min.js"></script>
        <script src="assets/js/biolife.framework.js"></script>
        <script src="assets/js/functions.js"></script>

        <!-- SCRIPT FOR COMBINED FILTERING (Unchanged) -->
        <script>
            $(document).ready(function () {
                var $villageFilter = $('#village-type-filter');
                var $provinceFilter = $('#province-filter');
                if ($.fn.niceSelect && $villageFilter.next().hasClass('nice-select')) {
                    $villageFilter.niceSelect('destroy');
                }
                $villageFilter.select2();
                if ($.fn.niceSelect && $provinceFilter.next().hasClass('nice-select')) {
                    $provinceFilter.niceSelect('destroy');
                }
                $provinceFilter.select2();
                function applyFilters() {
                    var selectedTypeId = $villageFilter.val();
                    var selectedProvinceCode = $provinceFilter.val();
                    var baseUrl = 'craftVillage';
                    var params = [];
                    if (selectedTypeId) {
                        params.push('typeID=' + selectedTypeId);
                    }
                    if (selectedProvinceCode) {
                        params.push('provinceCode=' + selectedProvinceCode);
                    }
                    var finalUrl = baseUrl;
                    if (params.length > 0) {
                        finalUrl += '?' + params.join('&');
                    }
                    window.location.href = finalUrl;
                }
                $villageFilter.on('change', applyFilters);
                $provinceFilter.on('change', applyFilters);
            });
        </script>
    </body>
</html>