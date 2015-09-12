$(document).ready(function() {
  gon.flash.forEach(function(msg){
    toast(msg, 4000);
  });
});
