﻿var wait = 2;
var jieguo = 0;
$(function(){
	var time;
	var font;
	$(".start").show();
	$(".start").click(function(){
		time = setInterval("gaocf()",0);$("#chengfa").animate({fontSize:"20px"});
		$(".start,.over").toggle();
	});
	$(".over").click(function(){
	clearInterval(time);
	for ( var i=0;i<test.length;i++ ){
                     var objj="tb_"+Math.floor(Math.random()*4);
		if ( $("#chengfa").html() == test[i] ) { openFace(objj);test.splice(i,1); }
	}
	$("#chengfa").animate({fontSize:"10px"}).animate({fontSize:"20px"});
	$(".start,.over").toggle();
	for ( i=1;i<=wait;i++ ) { setTimeout("count("+ i + ")",i*1000) }
		$(".start").hide();$(".count").show();		
	})
	$(document).keydown(function(event){
		if(event.keyCode == 13 || event.keyCode == 32){ 
			if ( $(".start").css("display") == "none" && $(".over").css("display") == "none" ) { return false; }		
			if ( $(".start").css("display") == "block" ) { $(".start").click() } else { $(".over").click() }
		};
		if(event.keyCode == 116){return false;}
	}) 
})
function count(num){
	if ( num == wait ) { $(".count").hide();$(".start").show();} 
	else { 
		jieguo = wait - num;
		$(".start").hide();$(".count").show();
		$(".count").html("启动(" + jieguo + "秒)")
	}
}
function gaocf(){
	var numSj = Math.floor(Math.random()*test.length);
	var chengfa = test[numSj];
	$("#chengfa").html(chengfa);
}
function openFace(obj){
	$("body").append("<img class='tmp_face' src='"+obj+".gif'/>");
	var winW = $(window).width();
	var winH = $(window).height();
	$(".tmp_face").css("top",winH/2-200).fadeIn().animate({"left":winW/2-200},500).delay(1000).fadeOut(function(){ $(this).remove() });
}