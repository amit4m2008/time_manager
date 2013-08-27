// when the DOM is ready...
$(document).ready(function () {
  // handle nav selection
  function selectNav() {
    $(this)
    .parents('ul:first')
    .find('a')
    .removeClass('selected')
    .end()
    .end()
    .addClass('selected');
  }

  $('#slider .navigation').find('a').click(selectNav);
  $('#nav').click(selectNav);

});