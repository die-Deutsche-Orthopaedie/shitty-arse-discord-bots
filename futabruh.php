<?php
    // constants that would be filled by the bash script
    $listenfilepath="[insert your listenfile name here]";
    $url="[insert your antics domain name here]/file/[insert your bucket name here]/";
    // btw this is one of the most :futabruh:in' borin' thing i've ever done in my life; so you can drive your little shitty ibm cloud to dump apks from apkpure for you even when you're outside and have no access to ibm cloud console
    // find your app url in ibm cloud console and add "futabruh.php?futabruh=sitename|keyword|[folder]"
    echo 'whatever the :futabruh: you inputted is: ' . htmlspecialchars($_GET["futabruh"]) . ';';
    echo "<br />";
    $listenfile=fopen($listenfilepath,"a+");
    $futabruh=fgets($listenfile);
    if(empty($futabruh)){
        echo $listenfilepath . ' is empty, ';
        fclose($listenfile);
        if (empty(htmlspecialchars($_GET["futabruh"]))){
            echo 'free to write any parameter into it with the format of ?futabruh=sitename|keyword|[folder]';
        } else {
            echo 'will write parameters into it';
            $listenfile2=fopen($listenfilepath,"w");
            fwrite($listenfile2,htmlspecialchars($_GET["futabruh"]));
            fclose($listenfile2);
        }
    } else {
        echo $listenfilepath . ' is not empty, that means a dump job is undergoin\'';
        echo "<br />";
        fclose($listenfile);
        echo "the current prossin' parameter is: " . $futabruh;
        echo "<br />";
        $bruh=explode('|', $futabruh);
        $sitename=$bruh[0];
        $keyword=$bruh[1];
        if (count($bruh)===3) {
            $foldername=$bruh[2];
        } else {
            $foldername=$bruh[1];
        }
        echo "and the log file could be accessed from <a href=\"log." . $sitename . "." . $foldername . ".txt\">here<a>";
        echo "<br />";
        echo "and the current prosessin' results could be accessed from <a href=\"results." . $sitename . "." . $foldername. ".txt\">here<a>";
        echo "<br />";
        echo "and the final prosessin' results would be uploaded into <a href=\"" . $url . $sitename . "." . $foldername . "/results." . $sitename . "." . $foldername . ".txt\">here<a>";
        echo "<br />";
        echo "and the log file would be uploaded into <a href=\"" . $url . $sitename . "." . $foldername . "/log." . $sitename . "." . $foldername . ".txt\">here<a>";
    }
?>
