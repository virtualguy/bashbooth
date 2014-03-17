<?php
if (!empty($_GET['multi'])) {
//exec('sudo /var/www/photobooth/photobooth.sh');
header('Location: http://photobooth/countdown.php');
}
else {
?>
<head>
<style>
body, th, tr, input {
font-size:200px;
/*font-family: "Segoe UI", Frutiger, "Frutiger Linotype", "Dejavu Sans", "Helvetica Neue", Arial, sans-serif;
/*font-family: "Lucida Grande", "Lucida Sans Unicode", "Lucida Sans", Geneva, Verdana, sans-serif;*/
font-family: Tahoma, Verdana, Segoe, sans-serif;

color:purple;
text-align:center;
border:2px solid;
border-radius:25px;
}
</style>
</head>
 
<form action="index.php" method="get">
<input type="hidden" name="multi" value="run">
<!-- <input type="submit" value="TAKE PHOTOBOOTH" style="position: absolute; top: 400px; left: 275px; font-size: 30pt; min-height: 200px;"> 
<input type="submit" value="START" style="position: center font-size: 30pt; min-height: 200px; min-width: 300px"> -->

<div style="width:95%;height:95%;position:absolute;vertical-align:middle;text-align:center;">
<!--    <button type="button" style="background-color:yellow;margin-left:auto;margin-right:auto;display:block;margin-top:22%;margin-bottom:0%">
mybuttonname</button> -->
    <input type="submit" value="Start" style="margin-left:auto;margin-right:auto;margin-top:15%; min-height: 300px; min-width: 600px">

</div>
</form>
 
<?php
}
?>
