<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" >
<head>
<title>Wark Creative Photobooth</title>
<style>
body, th, tr, input {
font-size:500px;
font-family: Tahoma, Verdana, Segoe, sans-serif;
color:purple;
text-align:center;
margin-top:7%;
/*border:2px solid;
border-radius:25px;
*/
}
</style>

<script type="text/javascript">
window.onload = function() {
/*	set your parameters(
number to countdown from, 
pause between counts in milliseconds, 
function to execute when finished
) 
*/
startCountDown(5, 1000, myFunction);
}

function startCountDown(i, p, f) {
//	store parameters
var pause = p;
var fn = f;
//	make reference to div
var countDownObj = document.getElementById("countDown");
if (countDownObj == null) {
//	error
alert("div not found, check your id");
//	bail
return;
}
countDownObj.count = function(i) {
//	write out count
countDownObj.innerHTML = i; 

if (i == 1) {
//	execute function
countDownObj.innerHTML = "Smile!"
fn();
//	stop
return;
}
setTimeout(function() {
//	repeat
countDownObj.count(i - 1);
},
pause
);
}
//	set it going
countDownObj.count(i);
}

function myFunction() {
window.location.href = '/takephoto.php';
}
</script>
</head>
<body>
<div id="countDown"></div>
</body>
</html>
