<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Tooltip test</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>

<i class="bi bi-exclamation-circle-fill text-warning"
   data-bs-toggle="tooltip"
   data-bs-html="true"
   data-bs-title="123 - Ceramic <br/> 456 - Wood Art">
</i>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
      return new bootstrap.Tooltip(tooltipTriggerEl)
    });
</script>

</body>
</html>