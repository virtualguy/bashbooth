<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" >
<head>
<title>Wark Creative Photobooth</title>
<style>
body, th, tr, input {
font-size:20px;
font-family: Tahoma, Verdana, Segoe, sans-serif;
color:purple;
text-align:center;
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
startCountDown(30, 1000, myFunction);
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

if (i == 0) {
//	execute function
fn();
//	stop
return;
}
else
{
// write out the countdown
countDownObj.innerHTML = i;
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
window.location.href = '/index.php';
}
</script>
</head>
<body>
<img src="photos/final/current.png" alt="Whoops can't find your image..." height="720"  align="middle">
<div id="countDown"></div>
</body>
</html>
