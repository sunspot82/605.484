// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function toggleVisible(blockId) {
   if ( $(blockId).visible())
      $(blockId).hide();
   else
      $(blockId).show();
}