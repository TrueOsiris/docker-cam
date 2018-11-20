<!DOCTYPE html>
<?php //$request = new ServerRequest(); ?>
<html>
<head>
    <title>surveillance</title>
	<script src="jquery.min.js"></script>
	<script>
		$(document).ready(function(){
			$("#mydiv").show();
			$("#mydiv").click(function(){
				$(this).hide();
			});
		});
	</script>
	<style>
		div {
			/* width: 40%; */
			padding-right: 10px;
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
	//echo fread($vars,filesize("vars.txt"));
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
		echo '<td class="tzero"><table><tr><td align="center" class="tzero">'.$streams[$i][0].": ".$streams[$i][1].'</td></tr>';
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
				${$currentcam.'-d'} = $dirs[sizeof($dirs)-1];
			} else {
				${$currentcam.'-d'} = $query[$currentcam.'-d'];
			}
			$dir_number = array_search(${$currentcam.'-d'}, $dirs);

			// show current day for cam $i + arrows
			echo '<tr><td align="center">';
			if (${$currentcam.'-d'} == $dirs[0]) {
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
				}
			}
			echo ' '.${$currentcam.'-d'}.' ('.($dir_number+1).'/'.sizeof($dirs).') ';
			if (${$currentcam.'-d'} == $dirs[sizeof($dirs)-1]) {
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
				}
			}
			echo '</td></tr>';
			echo '<tr><td align="center">';
			// get current file for cam $i for selected day from url, or set default
			$newpath = $imgloc[$i].'/'.${$currentcam.'-d'};
			$files = scandir($newpath, SCANDIR_SORT_ASCENDING);
			if (!isset ($query[$currentcam.'-f'])) {
				${$currentcam.'-f'} = $files[sizeof($files)-1];
			} else {
				${$currentcam.'-f'} = $query[$currentcam.'-f'];
			}
			$file_number = array_search(${$currentcam.'-f'},$files);
			
			// show current time for cam $i and current day + arrows
			if (${$currentcam.'-f'} == $files[0]) {
				echo '<<';
			} else {
				$query[$currentcam.'-f'] = $files[($file_number-1)];
				$query_result = $_SERVER['PHP_SELF'].'?'.http_build_query($query);
				echo '<a href="'.$query_result.'"><<</a>';
			}
			$cur_time = str_replace('-',':',explode('.',explode('__',${$currentcam.'-f'})[1])[0]);
			echo ' '.$cur_time.' ('.($file_number+1).'/'.sizeof($files).') ';
			if (${$currentcam.'-f'} == $files[sizeof($files)-1]) {
				echo '>>';
			} else {
				$query[$currentcam.'-f'] = $files[($file_number+1)];
				$query_result = $_SERVER['PHP_SELF'].'?'.http_build_query($query);
				echo '<a href="'.$query_result.'">>></a>';
			}
			
			echo '</td></tr>';
			echo '<tr><td align="center">';
			echo '<img src="'.$newpath.'/'.${$currentcam.'-f'}.'" width="512">';
			echo '</td></tr>';
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
