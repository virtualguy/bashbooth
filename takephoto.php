Test
<?php
printf("Click Click!");
$output = shell_exec('sudo /var/www/photobooth/photobooth.sh 2>&1');
print $output;
header('Location: http://photobooth/showphoto.php');
?>

