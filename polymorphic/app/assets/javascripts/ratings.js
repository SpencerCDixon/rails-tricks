function buildStarList(starNum){
  var starList = [];
  for(var i = 0; i < starNum; i++){
    //build the icon
    starList.push(buildStarIcon(i));
  }

  return starList;
}

function buildStarIcon(index){
  var $icon = $("<i>").addClass("fa fa-star-o");

  //build the link
  return $("<a>")
    .attr("href", "#")
    .attr("data-rating", index + 1)
    .html($icon);
}

function handleStarClick(e) {
  e.preventDefault();

  // trigger for click event
  var $trigger = $(e.currentTarget);

  // rating for the click event
  var rating = $trigger.attr("data-rating");

  $trigger.prevAll("a").andSelf().find("i")
    .removeClass("fa-star-o")
    .addClass("fa-star");

  $trigger.nextAll("a").find("i")
    .removeClass("fa-star")
    .addClass("fa-star-o");
}

function handleStarHover(e) {
  console.log("star was hovered");
}

$(function(){
  // clear out the rating container
  $("#rating-container").html("");
  // add the link to the container
  $("#rating-container").append(buildStarList(5));

  $("#rating-container a").on("click", handleStarClick)
  $("#rating-container a").on("mouseover", handleStarHover)
  

});
