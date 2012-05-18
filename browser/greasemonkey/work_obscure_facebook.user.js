// ==UserScript==
// @name        Disguise Facebook
// @namespace   http://coding.pressbin.com/15/Disguise-Facebook-using-Greasemonkey
// @include     http://www.facebook.com*
// @version     1
// ==/UserScript==
var doc = window.document;
var element = document.getElementById('blueBar');
var style = doc.createElement('span');
style.innerHTML = (<r><![CDATA[
    <style>
        body {margin-left:6em}
        #blueBar { background-color:#FFF; }
        #globalContainer { margin:0; }
        #pageLogo a { background:#FFF; }
        #jewelCase, .hasLeftCol #leftCol, #leftCol, .hasRightCol #rightCol, #rightCol, .lfloat { display:none; visibility:hidden;}
        #headNavOut, .hasLeftCol #mainContainer { background-color:#FFF; border-color:#FFF; }
        #pageNav li a { color:#000; }
        #navSearch { border:1px solid #CCC; }
        .hasLeftCol #contentCol { margin-left:5px; border-left:0; }
        #contentCol { width:1400px; }
        .profilePic { visibility:hidden; display:none }
        a, .UIActionLinks .comment_link, .uiLinkButton input { color:#555; }
        .commentable_item .ufi_section { background-color:#FFF; border-bottom:0; }
        .UIButton, .uiVideoThumb i { background-image:none; }
        .UIButton_Blue { background-color:#EEE; border-color:#CCC; color:#666; }
        .UIButton_Text { color:#666; }
        button.as_link { color:#555; }
        img, .spritemap_icons { opacity:0.02; }
        img:hover, .spritemap_icons:hover { opacity:0.99; }
        .UIMediaItem_Photo .UIMediaItem_Wrapper { border:0; }
        .commentable_item .ufi_section { border-top:1px solid #EEE; padding:5px 0 4px 20px; width:1400px; }
        .comments_add_box textarea { float:left; }
        .comments_add_box img { display:none; visibility:hidden }
        .comments_add_box_submit { float:none; margin:4px 10px 18px 0; }
        .UIImageBlock_Content { width:1400px; }
        .uiHeaderPage { display:none; visibility:hidden; }
        .pop_content h2.dialog_title { background-color:#FFF; color:#666; }
        .pop_content .dialog_buttons { background-color:#FFF; }
        .uiButtonConfirm { background-position:inherit; border:1px solid #999; }
        .uiButtonConfirm input { color:#000; }
        .pop_container_advanced { background:rgba(82, 82, 82, 0.3) none repeat scroll 0 0; padding:5px; }
        .uiStreamSource img, .spritemap_app_icons, .spritemap_7irdfb, .spritemap_4gdxwg, .sx_008a81, .spritemap_3m0cfm, .spritemap_12wnc8, .sx_63f489 { display:none; visibility:hidden; }
        .sx_fbb7d5, .mhs { display:inline; visibility:visible; }
    </style>
]]></r>).toString();
element.parentNode.insertBefore(style, element);
