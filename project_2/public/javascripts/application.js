// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function toggleVisible(idArr) {
   for(var i = 0; i < idArr.length; i++){
      var blockId = idArr[i];
      if ( $(blockId).visible() )
         $(blockId).hide();
      else
         $(blockId).show();
   }
}

