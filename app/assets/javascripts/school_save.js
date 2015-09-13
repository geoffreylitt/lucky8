$(document).ready(function () {
  $("#star-save").click(function (e){
    $.post(
      "/schools/" + $(this).attr("school-id") + "/toggle_save",
      function(data){
        $imageStar = $("#star-save .image-star");
        $imageStar.toggleClass("saved");

        // Update tooltip
        setTooltip($imageStar);
      }
    );
  });

  var setTooltip =  function ($imageStar) {
    if($imageStar.hasClass("saved")) {
      $imageStar.closest(".star-button").attr("data-tooltip", 
        "Unstar this school");
    } else {
      $imageStar.closest(".star-button").attr("data-tooltip", 
        "Star this school");
    }
  };

  // Set the tooltip on page load
  setTooltip($("#star-save .image-star"));
});
