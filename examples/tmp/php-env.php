<?php

/**
 * @Author: Cloudflying
 * @Date:   2021-09-16 21:57:51
 * @Last Modified by:   imxieke
 * @Last Modified time: 2021-10-17 20:52:00
 */


echo "\tPHP Env Check" . PHP_EOL ;
echo PHP_EOL;
// echo 'php version: ' . phpversion() . PHP_EOL; 
echo "\tSpec info\n----------------------------------" . PHP_EOL;
echo "show error \t\t: " . get_ini('display_errors');
echo "running memory \t\t: " . ini_get('memory_limit') . PHP_EOL;
echo "Post Size  \t\t: " . ini_get('post_max_size') . PHP_EOL;
echo "Upload File Size  \t: " . ini_get('upload_max_filesize') . PHP_EOL;
echo "Upload File Number  \t: " . ini_get('max_file_uploads') . PHP_EOL;
echo "Socket Timeout  \t: " . ini_get('default_socket_timeout') . PHP_EOL;
echo "Execution Timeout  \t: " . ini_get('max_execution_time') . PHP_EOL;
// print_r(ini_get_all());
// var_dump(get_ini('display_errors'));
// echo 'disable functions: ' . str_replace(',', ' ', ini_get('disable_functions'));

function get_ini($keyword)
{
	if(ini_get($keyword))
		return '√' . PHP_EOL;

	return 'x' . PHP_EOL;
}

echo PHP_EOL;