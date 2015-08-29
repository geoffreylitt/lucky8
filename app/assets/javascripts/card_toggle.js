$(document).on("page:change", function() {
  $(".card-details").hide();

  $("a.card-details-toggle").click(function(e) {
    e.preventDefault();

    $target = $(e.target);
    $details = $target.siblings(".card-details");

    $details.toggle({
      duration: 300
    });

    $target.hide();

  });
});
