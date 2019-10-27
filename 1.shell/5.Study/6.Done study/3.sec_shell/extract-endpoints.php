#!/usr/bin/php
<?php

function usage( $err=null ) {
	echo 'Usage: php '.$_SERVER['argv'][0]." -f/-d <source file/directory> [OPTIONS]\n\n";
	echo "Options:\n";
	echo "\t-b\tbeautify javascript files before parsing (requires js-beautify)\n";
	echo "\t--bb\tbeautify and update source file (requires js-beautify)\n";
	echo "\t-c\tsearch for comments instead of urls\n";
	echo "\t-d\tset source directory (required)\n";
	echo "\t-e\tfile to load (example: js,php,asp) (default: js)\n";
	echo "\t-f\tset source file (required)\n";
	echo "\t-g\tset regexp source file\n";
	echo "\t--gg\tset regexp\n";
	echo "\t-h\tforce host if none\n";
	echo "\t-i\textensions we don't want to display separated by a comma (example: gif,jpg,png)\n";
	echo "\t-k\tsearch for keywords instead of urls\n";
	echo "\t-l\tfollow location\n";
	echo "\t-n\textensions file we don't want to read separated by a comma (example: gif,jpg,png)\n";
	echo "\t-r\talso scan subdirectories\n";
	echo "\t-s\tforce https if no scheme\n";
	echo "\t-t\ttest the urls found\n";
	echo "\t-u\tremove duplicates (at your own risk!)\n";
	echo "\t-v\tverbose mode: 0=all, 1=findings, 2=remove extra text\n";
	echo "\n";
	if( $err ) {
		echo 'Error: '.$err."!\n";
	}
	exit();
}


require_once( 'Utils.php' );

define( 'MODE_ENDPOINT', 1 );
define( 'MODE_KEYWORD', 2 );
define( 'MODE_COMMENT', 3 );
define( 'DEFAULT_MODE', MODE_ENDPOINT );


$options = '';
$options .= 'b'; // beautify
$options .= 'c'; // looking for comments instead of enpoints
$options .= 'd:'; // source directory
$options .= 'e:'; // extension
$options .= 'f:'; // source file
$options .= 'g:'; // regexp file
$options .= 'h:'; // set host if none
$options .= 'i:'; // ignore extensions (list)
$options .= 'k'; // looking for keywords instead of enpoints
$options .= 'l'; // follow location
$options .= 'n:'; // ignore extensions (read)
$options .= 'r'; // recursive (scan subdir)
$options .= 's'; // force https
$options .= 't'; // test url
$options .= 'v:'; // verbose
$long_options = ['bb','gg:'];
$t_options = getopt( $options, $long_options );
//var_dump($t_options);
if( !count($t_options) ) {
	usage();
}


if( isset($t_options['t']) ) {
	$_test = true;
} else {
	$_test = false;
}

if( isset($t_options['r']) ) {
	$_recurs = true;
} else {
	$_recurs = false;
}

if( isset($t_options['l']) ) {
	$_location = true;
} else {
	$_location = false;
}

if( isset($t_options['s']) ) {
	$_scheme = 'https';
} else {
	$_scheme = 'http';
}

if( isset($t_options['b']) || isset($t_options['bb']) ) {
	$_beautify = true;
} else {
	$_beautify = false;
}
if( isset($t_options['bb']) ) {
	$_beautify_alter = true;
} else {
	$_beautify_alter = false;
}

if( isset($t_options['h']) ) {
	$_host = $t_options['h'];
} else {
	$_host = null;
}

if( isset($t_options['v']) ) {
	$_verbose = (int)$t_options['v'];
} else {
	$_verbose = 0;
}

if( isset($t_options['f']) ) {
	$f = $t_options['f'];
	if( !is_file($f) ) {
		usage( 'Source file not found' );
	} else {
		$_t_source = [$f];
	}
} elseif( isset($t_options['d']) ) {
	$d = $t_options['d'];
	if( !is_dir($d) ) {
		usage( 'Source file not found' );
	} else {
		$d = rtrim( $d, '/' );
		if( isset($t_options['e']) ) {
			$_loadext = explode( ',', $t_options['e'] );
		} else {
			$_loadext = ['js'];
		}
		$_t_source = [];
		foreach( $_loadext as $e ) {
			if( $_recurs ) {
				$output = null;
				if( $e == '*' ) {
					$cmd = 'find "'.escapeshellcmd($d).'" -type f 2>/dev/null';
				} else {
					$cmd = 'find "'.escapeshellcmd($d).'" -type f -name "*.'.$e.'" 2>/dev/null';
				}
				//echo $cmd."\n";
				exec( $cmd, $output );
				$_t_source = array_merge( $_t_source, $output );
			} else {
				if( $e == '*' ) {
					$_t_source = array_merge( $_t_source, glob( $d.'/*.'.trim($e) ) );
				} else {
					$_t_source = array_merge( $_t_source, glob( $d.'/*.'.trim($e) ) );
				}
			}
		}
	}
} else {
	usage();
}

if( isset($t_options['i']) ) {
	$_ignore = explode( ',', $t_options['i'] );
} else {
	$_ignore = null;
}

if( isset($t_options['n']) ) {
	$_dontread = explode( ',', $t_options['n'] );
} else {
	$_dontread = [];
}

$_url_chars = '[a-zA-Z0-9\-\.\?\#&=_:/]';
$_regexp = [
	'|["]('.$_url_chars.'+/'.$_url_chars.'+)?["]|',
	'#[\'"\(].*(http[s]?://.*?)[\'"\)]#',
	'#[\'"\(](http[s]?://.*?).*[\'"\)]#',
	'#[\'"\(]([^\'"\(]*\.sdirect[^\'"\(]*?)[\'"\)]#',
	'#[\'"\(]([^\'"\(]*\.htm[^\'"\(]*?)[\'"\)]#',
	'#[\'"\(]([^\'"\(]*\.html[^\'"\(]*?)[\'"\)]#',
	'#[\'"\(]([^\'"\(]*\.php[^\'"\(]*?)[\'"\)]#',
	'#[\'"\(]([^\'"\(]*\.asp[^\'"\(]*?)[\'"\)]#',
	'#[\'"\(]([^\'"\(]*\.aspx[^\'"\(]*?)[\'"\)]#',
	//'#[\'"\(]([^\'"\(]*\.json[^\'"\(]*?)[\'"\)]#',
	//'#[\'"\(]([^\'"\(]*\.xml[^\'"\(]*?)[\'"\)]#',
	//'#[\'"\(]([^\'"\(]*\.ini[^\'"\(]*?)[\'"\)]#',
	//'#[\'"\(]([^\'"\(]*\.conf[^\'"\(]*?)[\'"\)]#',
	//'#href\s*=\s*[\'"](.*?)[\'"]#',
	'#href\s*=\s*[\'](.*?)[\']#',
	'#href\s*=\s*["](.*?)["]#',
	'#src\s*=\s*[\'](.*?)[\']#',
	'#src\s*=\s*["](.*?)["]#',
	//'#src[\s]*=[\s]*[\'"](.*?)[>]#',
	'#url\s*[:=].*[\'](.*?)[\']#',
	'#url\s*[:=].*?["](.*?)["]#',
	'#urlRoot\s*:.*[\'](.*?)[\']#',
	'#urlRoot\s*:.*?["](.*?)["]#',
	'#endpoint[s]?\s*:.*[\'](.*?)[\']#',
	'#endpoint[s]?\s*:.*?["](.*?)["]#',
	'#[\'"]script[\'"]\s*:\s*[\'"](.*?)[\'"]#',
	'#\.ajax\s*\(\s*[\'"](.*?)[\'"]#',
	'#\.get\s*\(\s*[\'"](.*?)[\'"]#',
	'#\.post\s*\(\s*[\'"](.*?)[\'"]#',
	'#\.load\s*\(\s*[\'"](.*?)[\'"]#',
	//'#href|src\s*=\s*["](.*?)["]#',
	//'#href|src\s*=\s*[\'](.*?)[\']#',
	//'#endpoint[s]?|url|urlRoot|href\s*:.*["](.*?)["]#',
	//'#endpoint[s]?|url|urlRoot|src\s*:.*[\'](.*?)[\']#',
];
$_comment = [
	'#<!--(.*?)-->#s', // <!-- ->>
	'#/\*(.*?)\*/#s', // /* ... */
	'#//(.*)#', // // ...
];
$_comments_regexp = '('.implode( '|', $_comment ).')';
$_keywords_sensitive = [
	'[a-fA-F0-9]{32}(?:[a-fA-F0-9]{8})?(?:[a-fA-F0-9]{16})?(?:[a-fA-F0-9]{8})?(?:[a-fA-F0-9]{32})?(?:[a-fA-F0-9]{32})?', // mdx
	//'[\'\"][a-f0-9]{32}[\'\"]', // md5
	'[\'\"][a-f0-9]{40}[\'\"]', // sometimes...
	'[1-9][0-9]+-[0-9a-zA-Z]{40}', // Twitter
	'EAACEdEose0cBA[0-9A-Za-z]+', // Facebook
	'AIza[_0-9A-Za-z\-]{35}', // YouTube/Gmail/Gdrive api key
	'[0-9]+-[0-9A-Za-z_]{32}\.apps\.googleusercontent\.com', // YouTube/Gmail/Gdrive oauth id
	'sk_live_[0-9a-z]{32}', // Picatic
	'sk_live_[0-9a-zA-Z]{24}', // Stripe standard restricted
	'rk_live_[0-9a-zA-Z]{24}', // Stripe
	'sq0atp-[_0-9A-Za-z\-]{22}', // Square access token
	'sq0csp-[_0-9A-Za-z\-]{43}', // Square oauth secret
	'access_token\$production\$[0-9a-z]{16}\$[0-9a-f]{32}', // PayPal Braintree
	'amzn\.mws\.[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}', // Amazon MWS
	'AC[0-9a-fA-F]{32}', // Twilio client
	'SK[0-9a-fA-F]{32}', // Twilio secret
	'key-[0-9a-zA-Z]{32}', // MailGun
	'[0-9a-f]{32}-us[0-9]{1,2}', // MailChimp
	'[\'\"][A-Z0-9]{20}[\'\"]', // aws secret
	'[\'\"][a-zA-Z0-9/]{40}[\'\"]', // aws api key
	'AKIA[0-9A-Z]{16}', // AWS client id
	'ASIA[0-9A-Z]{16}', // AWS client id
	// '([^A-Z0-9]|^)(AKIA|A3T|AGPA|AIDA|AROA|AIPA|ANPA|ANVA|ASIA)[A-Z0-9]{12,}', // AWS by TomNomNom
	// '[0-9a-zA-Z/+]{40}', // AWS secret
	// '[0-9a-zA-Z_]{5,31}', // Bitly client id
	'R_[0-9a-f]{32}', // Bitly secret
	// '[0-9]{13,17}', // Facebook client
	// '[0-9a-f]{32}', // Facebook secret
	// '[0-9a-f]{32}', // flickr client
	// '[0-9a-f]{16}', // flickr secret
	// '[0-9A-Z]{48}', // foursquare client
	// '[0-9A-Z]{48}', // foursquare secret
	// '[0-9a-z]{12}', // LinkedIn client
	// '[0-9a-zA-Z]{16}', // LinkedIn secret
	// '[0-9a-zA-Z]{18,25}', // twitter client
	// '[0-9a-zA-Z]{35,44}', // twitter secret
];
$_keywords_insensitive = [
	//'auth',
	//'private',
	//'mysql',
	//'dump',
	//'login',
	//'password',
	//'credential',
	//'oauth',
	//'token',
	'access_token',
	'access_secret',
	'apikey',
	'api_key',
	'app_key',
	'client_secret',
	'consumer_secret',
	'customer_secret',
	'user_secret',
	'secret_key',
	'access_key',
	'fb_secret',
	'dbpasswd',
	'DB_PASSWORD',
	'DB_USERNAME',
	'JEKYLL_GITHUB_TOKEN',
	'oauth_token',
	'PT_TOKEN',
	'SF_USERNAME',
	'-----BEGIN RSA PRIVATE KEY-----',
	'-----BEGIN EC PRIVATE KEY-----',
	'-----BEGIN PRIVATE KEY-----',
	'-----BEGIN PGP PRIVATE KEY BLOCK-----',
	'.apps.googleusercontent.com',
	'sq0atp',
	'sq0csp',
	'sk_live_',
	'rk_live_',
	'xoxb-',
	//'secret',
	'gsecr',
	//'username',
	'id_rsa',
	'id_dsa',
	//'\.json',
	//'\.xml',
	//'\.yaml',
	//'\.saml',
	//'config',
	'\.pem',
	'\.ppk',
	'\.sql',
	//'\.conf',
	//'\.ini',
	//'\.php',
	//'\.asp',
	's3\.amazonaws\.com',
	'storage\.googleapis\.com',
	'storage\.cloud\.google\.com',
	'\.digitaloceanspaces\.com',
];
$_keywords_sensitive_regexp = '('.implode( '|', $_keywords_sensitive ).')';
$_keywords_insensitive_regexp = '('.implode( '|', $_keywords_insensitive ).')';

$_mode = MODE_ENDPOINT;
if( isset($t_options['k']) ) {
	$_mode = MODE_KEYWORD;
	$_regexp = array_merge( $_keywords_sensitive, $_keywords_insensitive );
}
elseif( isset($t_options['c']) ) {
	$_mode = MODE_COMMENT;
	$_regexp = array_merge( $_comment );
}

if( isset($t_options['g']) ) {
	$g = $t_options['g'];
	if( !is_file($g) ) {
		usage( 'Regexp file not found' );
	}
	$_regexp = file( $g, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES );
}
if( isset($t_options['gg']) ) {
	$_regexp = [ $t_options['gg'] ];
	$_keywords_sensitive_regexp = $t_options['gg'];
	$_comments_regexp = $_comment = $t_options['gg'];
}

$n_regexp = count( $_regexp );
if( $_verbose < 2 ) {
	echo $n_regexp." regexp loaded.\n";
	echo count($_t_source)." files loaded.\n\n";
}


foreach( $_t_source as $s )
{
	$p = strrpos( $s, '.' );
	if( $p !== false ) {
		$ext = substr( $s, $p+1 );
		if( in_array($ext,$_dontread) ) {
			continue;
		}
	}

	if( $_beautify ) {
		ob_start();
		system( 'js-beautify '.$s );
		$buffer = ob_get_contents();
		ob_end_clean();
		if( $_beautify_alter ) {
			file_put_contents( $s, $buffer );
		}
	} else {
		$buffer = file_get_contents( $s );
	}
	
	ob_start();
	
	if( $_mode == MODE_KEYWORD )
	{
		$ss = escapeshellcmd( $s );
		$ss = str_replace( '\?', '?', $s );

		$output = null;
		$cmd = 'egrep -n "'.$_keywords_sensitive_regexp.'" "'.$ss.'"';
		echo $cmd."\n";
		exec( $cmd, $output );
		$n_sensitive = printColoredGrep( $_keywords_sensitive_regexp, implode("\n",$output), 1 );
		
		if( $_keywords_insensitive_regexp != $_keywords_sensitive_regexp ) {
			$output = null;
			$cmd = 'egrep -i -n "'.$_keywords_insensitive_regexp.'" "'.$ss.'"';
			exec( $cmd, $output );
			$n_insensitive = printColoredGrep( $_keywords_insensitive_regexp, implode("\n",$output), 0 );
		}
		
		$n_total = $n_sensitive + $n_insensitive;
		if( $_verbose < 2 ) {
			echo $n_total." keywords found!\n";
		}
	}
	elseif( $_mode == MODE_COMMENT )
	{
		$n_total = 0;
		foreach( $_comment as $r ) {
			$m = preg_match_all( $r, $buffer, $matches );
			//var_dump( $matches );
			if( $m ) {
				$n_total += count( $matches[0] );
				foreach( $matches[0] as $m ) {
					echo preg_replace('#\s+#',' ',$m)."\n";
				}
			}
		}
		/*$output = null;
		$cmd = 'egrep -n "'.$_comments_regexp.'" "'.$s.'"';
		var_dump( $cmd );
		exec( $cmd, $output );
		$n_total = printColoredGrep( $_comments_regexp, implode("\n",$output), 1 );
		echo $n_total." keywords found!\n";*/
		if( $_verbose < 2 ) {
			echo $n_total." comments found!\n";
		}
	}
	else
	{
		list($t_final,$t_possible) = run( $buffer );
		clean( $t_final );
		$n_final = count($t_final);
		$n_possible = count($t_possible);
		
		if( $n_final ) { 
			$t_final = array_unique( $t_final );
			$n_final = count( $t_final );
			foreach( $t_final as $u ) {
				echo $u;
				if( $_test && stripos('http',$u)==0 ) {
					$http_code = testUrl( $u, $_location );
					if( $http_code == 200 ) {
						$color = 'green';
					} else {
						$color = 'red';
					}
					$txt = ' ('.$http_code.')';
					Utils::_print( $txt, $color );
				}
				echo "\n";
			}
		}
		if( $_verbose < 2 ) {
			echo $n_final." urls found!\n";
		}
		
		if( $n_possible && $_verbose<2 ) {
			Utils::_println( str_repeat('-',100), 'light_grey' );
			$t_possible = array_unique( $t_possible );
			Utils::_println( implode( "\n",$t_possible), 'light_grey' );
			Utils::_println( $n_possible." possible...", 'light_grey' );
		}
		
		$n_total = $n_possible + $n_final;
	}

	$buffer = ob_get_contents();
	ob_end_clean();

	if( $_verbose == 0 || $n_total ) {
		if( $_verbose < 2 ) {
			Utils::_println( "Loading: ".$s, 'yellow' );
		}
		echo $buffer;
		if( $_verbose < 2 ) {
			echo "\n";
		}
	}
}


function testUrl( $url, $follow_location )
{
	$c = curl_init();
	curl_setopt( $c, CURLOPT_URL, $url );
	curl_setopt( $c, CURLOPT_CUSTOMREQUEST, 'HEAD' );
	//curl_setopt( $c, CURLOPT_HEADER, true );
	//curl_setopt( $c, CURLOPT_SSL_VERIFYPEER, false );
	curl_setopt( $c, CURLOPT_NOBODY, true );
	curl_setopt( $c, CURLOPT_CONNECTTIMEOUT, 3 );
	curl_setopt( $c, CURLOPT_FOLLOWLOCATION, $follow_location );
	curl_setopt( $c, CURLOPT_RETURNTRANSFER, true );
	$r = curl_exec( $c );
	
	$t_info = curl_getinfo( $c );
	
	return $t_info['http_code'];
}


function printColoredGrep( $regexp, $str, $case_sensitive )
{
	//$p = 0;
	//$l = strlen( $str );
	//$m = preg_match_all( '#'.$regexp.'#i', $str, $matches, PREG_OFFSET_CAPTURE );
	//var_dump( $matches );
	
	if( $case_sensitive ) {
		$flag = '';
	} else {
		$flag = 'i';
	}
	
	$colored = preg_replace( '#'.$regexp.'#'.$flag, "\033[0;32m".'\\1'."\033[0m", $str, -1, $cnt );
	if( $cnt ) {
		echo $colored."\n";
	}
	//var_dump( $str );
	//Utils::_print( '('.($line>=0?$line:'-').') ', 'yellow' );
	/*
	if( $m ) {
		$n = count( $matches[0] );
		//var_dump($n);
		for( $i=0 ; $i<$n ; $i++ ) {
			$s1 = substr( $str, $p, ($matches[0][$i][1]-$p) );
			$s2 = substr( $str, $matches[0][$i][1], $l );
			$p = $matches[0][$i][1] + $l;
			//$p = $matches[$i][1] + $l;
			Utils::_print( $s1, 'white' );
			Utils::_print( $s2, 'light_green' );
			//break;
		}
	}
	
	$s3 = substr( $str, $p );
	Utils::_print( $s3, 'white' );*/
	return $cnt;
}


function run( $buffer )
{
	global $_regexp, $_ignore, $_url_chars;
	//var_dump( $_regexp );

	$t_all = [];
	
	foreach( $_regexp as $r ) {
		$m = preg_match_all( $r.'i', $buffer, $matches );
		//var_dump( $matches );
		if( $m ) {
			//var_dump( $matches );
			$t_all = array_merge( $t_all, $matches[1] );
		}
	}
	
	$t_exclude_extension = [ ];
	$t_exclude_domain = [ ];
	$t_exclude_scheme = [ 'javascript', 'mailto', 'data', 'about', 'file' ];
	$t_exclude_string = [ ];
	$t_exclude_possible = [ '+', '==', 'MM/DD/YYYY', 'text/plain', 'text/html', 'text/css', 'text/javascript', 'application/x-www-form-urlencoded', 'application/javascript', 'application/json', 'image/jpeg', 'image/gif', 'image/png', 'www.w3.org' ];

	$t_possible = [];
	$t_all = array_unique( $t_all );
	//var_dump( $t_all );

	foreach( $t_all as $k=>&$url )
	{
		//var_dump($url);
		//$url = urldecode( $url );
		
		$test = preg_replace( '#[^0-9a-zA-Z]#', '', $url );
		if( $test == '' ) {
			unset( $t_all[$k] );
			continue;
		}
	 	
		$parse = parse_url( $url );
		//var_dump($parse);
		if( !$parse ) {
			unset( $t_all[$k] );
			$t_possible[] = $url;
			continue;
		}
		
		foreach( $t_exclude_string as $s ) {
			if( strstr($url,$s) ) {
				unset( $t_all[$k] );
				$t_possible[] = $url;
				continue;
			}
		}
		
		foreach( $t_exclude_possible as $s ) {
			if( strstr($url,$s) ) {
				unset( $t_all[$k] );
				$t_possible[] = $url;
				continue;
			}
		}
		
		if( isset($parse['scheme']) && in_array($parse['scheme'],$t_exclude_scheme) ) {
			unset( $t_all[$k] );
			$t_possible[] = $url;
			continue;
		}
		
		if( isset($parse['path']) && is_array($_ignore) && count($_ignore) ) {
			$p = strrpos( $parse['path'], '.' );
			if( $p !== false ) {
				$ext = substr( $parse['path'], $p+1 );
				if( in_array($ext,$_ignore) ) {
					unset( $t_all[$k] );
					continue;
				}
			}
		}
		
		if( $url[0] == '#' ) {
			unset( $t_all[$k] );
			$t_possible[] = $url;
			continue;
		}
		
		if( isset($parse['path']) )
		{
			if( strstr($parse['path'],' ') !== false ) {
				$tmp = explode( ' ', $parse['path'] );
				$parse['path'] = $tmp[0];
			}
			
			$kk = preg_replace('|'.$_url_chars.'|i','',$parse['path']);
			if( strlen($kk) != 0 ) {
				unset( $t_all[$k] );
				$t_possible[] = $url;
				continue;
			}
		}
	}
	
	//var_dump($t_all);
	return [$t_all,$t_possible];
}


function clean( &$t_urls )
{
	global $_scheme, $_host, $_ignore;
	
	$scheme = $host = '';
	
	foreach( $t_urls as &$u )
	{
		//var_dump( $u );
		$scheme = $host = '';
		$parse = parse_url( $u );
		//var_dump( $parse );
		
		if( isset($parse['host']) ) {
			$host = $parse['host'];
		} elseif( $_host ) {
			$host = $_host;
			$u = ltrim( $u, '/' );
			$u = $host . '/' . $u;
		}
		
		if( isset($parse['scheme']) && $parse['scheme'] != NULL ) {
			$scheme = $parse['scheme'];
		} elseif( $host ) {
			$scheme = $_scheme;
			$u = ltrim( $u, '/' );
			$u = $scheme . '://' . $u;
		}
		
		if( strstr($u,' ') !== false ) {
			$tmp = explode( ' ', $u );
			$u = $tmp[0];
		}
	}
}

