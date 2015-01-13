function buildStarList(starNum){
  var starList = [];
  for(var i = 0; i < starNum; i++){
    starList.push(buildStarIcon(i));
  }

  return starList;
}

function buildStarIcon(index){
  var $icon = $("<i>").addClass("fa fa-star-o");

  return $("<a>")
    .attr("href", "#")
    .attr("data-rating", index + 1)
    .html($icon);
}

function handleStarClick(e) {
  e.preventDefault();

  var $trigger = $(e.currentTarget);
  var rating = $trigger.attr("data-rating");

  $trigger.prevAll("a").andSelf().find("i")
    .removeClass("fa-star-o")
    .addClass("fa-star");

  $trigger.nextAll("a").find("i")
    .removeClass("fa-star")
    .addClass("fa-star-o");

  var $hidden = $('#comment_rating');
  $hidden.val(rating)
}

function handleStarHover(e) {
  var $trigger = $(e.currentTarget);
  $trigger.addClass("fa-lg");
}

function handleStarHoverOut(e) {
  var $trigger = $(e.currentTarget);
  $trigger.removeClass("fa-lg");
}

$(function(){
  // clear out the rating container
  $("#rating-container").html("");

  // add the link to the container
  $("#rating-container").append(buildStarList(5));

  $("#rating-container a").on("click", handleStarClick);
  $("#rating-container a").on("mouseover", handleStarHover);
  $("#rating-container a").on("mouseout", handleStarHoverOut);
});
