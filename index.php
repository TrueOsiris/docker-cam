<!DOCTYPE html>
<?php //$request = new ServerRequest(); ?>
<html>
<head>
    <title>surveillance</title>
	<script src="jquery.min.js"></script>
	<script>
		$(document).ready(function () {
		<?php // for ($k=0;$k<12;$k++) { ?>
			$("#divvid<?php //echo $k ?>").css({"display":"none"});; // hide video div on start
			$("#divvidpic<?php //echo $k ?>").mouseover(
			function () {
				$(this).find("#divvid<?php //echo $k ?>").css({"display":"block"});
				$(this).find("#divpic<?php //echo $k ?>").css({"display":"none"});
                $(this).find("#divvid<?php //echo $k ?>").children("video")[0].play();
            });
			$("#divvidpic<?php //echo $k ?>").mouseleave(
			function () {
				$(this).find("#divvid<?php //echo $k ?>").css({"display":"none"});;
				$(this).find("#divpic<?php //echo $k ?>").css({"display":"block"});;
                $(this).find("#divvid<?php //echo $k ?>").children("video")[0].stop();
            });	
		<?php //} ?>
		});
	</script>
	<style>
		div {
			/* width: 40%; */
			padding: 0px;
			display: inline-block;
			color: black;
		}
		.tborder {
			border: 1px solid grey;
			border-collapse: collapse;
		}
		.tzero {
			padding: 0px;
			border-spacing: 0px;	
		}
		table, tr, td {
			padding: 0px;
			border-spacing: 0px;
			margin: 0px;
			spacing: 0px;
		}
	</style>
</head>
<body align="center">
 <!--<div id="mydiv" hidden >JQuery is functional</div>-->
 <div align="center">
 <? $query = $_GET;
	$vars = fopen("vars.txt","r") or die ("unable to open vars.txt");
	while(!feof($vars)) {
		$content = fgets($vars);
		if (trim($content) !== '') {
			$streams[] = explode(': ',$content);
		}
	}
	fclose($vars);
 	echo '<table class="tborder tzero">';
 	for ($i = 0; $i < sizeof($streams); $i++) {
		$currentcam = 'c'.$i;
		$imgloc[$i] = trim($streams[$i][0]).'/pics';
		if ($i % 2 == 0) {
			echo '<tr style="border-bottom: 1px; color: black;">';
		}
		echo '<td class="tzero"><table><tr><td align="center" class="tzero">'.$streams[$i][0].'</td></tr>';
		// put list of streamX/pics subdirs into array and sort them
		if (is_dir($imgloc[$i])) {
			$dirs='';
			if ($dh = opendir($imgloc[$i])) {
				while (($file = readdir($dh)) !== false) {
					if (filetype($imgloc[$i].'/'.$file) == 'dir' && substr($file,0,2) == "20") {
						$dirs[]=$file;
					}
				}
				closedir($dh);
			}
			sort($dirs);
			
			// get current day for cam $i from url or set default
			if (!isset ($query[$currentcam.'-d'])) {
				$query[$currentcam.'-d'] = $dirs[sizeof($dirs)-1];
			}
			$dir_number = array_search($query[$currentcam.'-d'], $dirs);
			// show current day for cam $i + arrows
			echo '<tr><td align="center">';
			if ($query[$currentcam.'-d'] == $dirs[0]) {
				echo '<<';
			} else {	
				$query[$currentcam.'-d'] = $dirs[($dir_number-1)];
				unset($tempf);
				if (isset($query[$currentcam.'-f'])) {
					$tempf = $query[$currentcam.'-f']; 
					unset($query[$currentcam.'-f']);
				}
				$query_result = $_SERVER['PHP_SELF'].'?'.http_build_query($query);
				echo '<a href="'.$query_result.'"><<</a>';
				$query[$currentcam.'-d'] = $dirs[($dir_number)];
				if (isset($tempf)) {
					$query[$currentcam.'-f'] = $tempf;
					unset($tempf);
				}
			}
			echo ' '.$query[$currentcam.'-d'].' ('.($dir_number+1).'/'.sizeof($dirs).') ';
			if ($query[$currentcam.'-d'] == $dirs[sizeof($dirs)-1]) {
				echo '>>';
			} else {
				$query[$currentcam.'-d'] = $dirs[($dir_number+1)];
				unset($tempf);
				if (isset($query[$currentcam.'-f'])) {
					$tempf = $query[$currentcam.'-f']; 
					unset($query[$currentcam.'-f']);
				}
				$query_result = $_SERVER['PHP_SELF'].'?'.http_build_query($query);
				echo '<a href="'.$query_result.'">>></a>';
				$query[$currentcam.'-d'] = $dirs[($dir_number)];
				if (isset($tempf)) {
					$query[$currentcam.'-f'] = $tempf;
					unset($tempf);
				}
			}
			echo '</td></tr>';
			echo '<tr><td align="center">';
			// get current file for cam $i for selected day from url, or set default
			$newpath = $imgloc[$i].'/'.$query[$currentcam.'-d'];
			$files = scandir($newpath, SCANDIR_SORT_ASCENDING);
			if (!isset ($query[$currentcam.'-f'])) {
				$query[$currentcam.'-f'] = $files[sizeof($files)-1];
			}
			$file_number = array_search($query[$currentcam.'-f'],$files);
			
			// show current time for cam $i and current day + arrows
			// go 10 pics back
			if ($file_number - 10 < 1) {
				echo '<<10 ';
			} else {
				$query[$currentcam.'-f'] = $files[($file_number - 10)];
				$query_result = $_SERVER['PHP_SELF'].'?'.http_build_query($query);
				echo '<a href="'.$query_result.'"><<10</a> ';
				$query[$currentcam.'-f'] = $files[($file_number)];
			}
			// previous pic
			if ($query[$currentcam.'-f'] == $files[0]) {
				echo '<<';
			} else {
				$query[$currentcam.'-f'] = $files[($file_number-1)];
				$query_result = $_SERVER['PHP_SELF'].'?'.http_build_query($query);
				echo '<a href="'.$query_result.'"><<</a>';
				$query[$currentcam.'-f'] = $files[($file_number)];
			}
			$cur_time = str_replace('-',':',explode('.',explode('__',$query[$currentcam.'-f'])[1])[0]);
			echo ' '.$cur_time.' ('.($file_number+1).'/'.sizeof($files).') ';
			// next pic
			if ($query[$currentcam.'-f'] == $files[sizeof($files)-1]) {
				echo '>>';
			} else {
				$query[$currentcam.'-f'] = $files[($file_number+1)];
				$query_result = $_SERVER['PHP_SELF'].'?'.http_build_query($query);
				echo '<a href="'.$query_result.'">>></a>';
				$query[$currentcam.'-f'] = $files[($file_number)];
			}
			// go 10 pics forward
			if ($file_number + 10 > sizeof($files)-1) {
				echo ' 10>> ';
			} else {
				$query[$currentcam.'-f'] = $files[($file_number + 10)];
				$query_result = $_SERVER['PHP_SELF'].'?'.http_build_query($query);
				echo ' <a href="'.$query_result.'">10>></a> ';
				$query[$currentcam.'-f'] = $files[($file_number)];
			}
			//echo $file_number;
			
			echo '</td></tr>';
			// get timelapse video when hovering
			if ($query[$currentcam.'-d'] == $dirs[sizeof($dirs)-1]) {
				$vid = $imgloc[$i].'/'.$query[$currentcam.'-d'].'_temp_timelapse.mp4';
			} else {
				$vid = $imgloc[$i].'/'.$query[$currentcam.'-d'].'_timelapse.mp4';
			}
			echo '<tr><td align="center">';
			echo '<div id="divvidpic">';
			echo '<div id="divpic">';
			echo '<img id="pic" src="'.$newpath.'/'.$query[$currentcam.'-f'].'" width="512">';
			echo '</div>';
			echo '<div id="divvid">';
			echo '<video id="vid" preload="auto" width="512" loop><source src="'.$vid.'" type="video/mp4"></video>';
			
			//echo '<div id="divvidpic'.$i.'">';
			//echo '<div id="divpic'.$i.'">';
			//echo '<img id="pic'.$i.'" src="'.$newpath.'/'.${$currentcam.'-f'}.'" width="512">';
			//echo '</div>';
			//echo '<div id="divvid'.$i.'">';
			//echo '<video id="vid'.$i.'" preload="auto" width="512" loop><source src="'.$vid.'" type="video/mp4"></video>';
			
			echo '</div>';
			echo '</div>';
			echo '</td></tr></table>';
			//echo $_SERVER['DOCUMENT_ROOT'];
		}
		echo "</td>";
		if (($i-1) % 2 == 0) {
			echo '</tr>';
		}
	}
	echo '</table>';
	
 ?>
 </div>
</body>
</html>
