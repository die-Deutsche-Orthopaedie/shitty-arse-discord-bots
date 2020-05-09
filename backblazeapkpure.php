<?php
    // constants
    $listenfilepath="bruh.txt";
    $url="https://kawaii.toiletchan.xyz/file/[insert your bucket name here]/";
    // btw this is one of the most :futabruh:in' borin' thing i've ever done in my life; so you can drive your little shitty ibm cloud to dump apks from apkpure for you even when you're outside and have no access to ibm cloud console
    // find your app url in ibm cloud console and add "backblazeapkpure.php?futabruh=[insert keyword here or add a | followin' folder you want]"
    echo 'whatever the :futabruh: you inputted is: ' . htmlspecialchars($_GET["futabruh"]) . ';';
    echo "<br />";
    $listenfile=fopen($listenfilepath,"a+");
    $futabruh=fgets($listenfile);
    if(empty($futabruh)){
        echo $listenfilepath . ' is empty, will write parameters into it';
        fclose($listenfile);
        $listenfile2=fopen($listenfilepath,"w");
        fwrite($listenfile2,htmlspecialchars($_GET["futabruh"]));
        fclose($listenfile2);
    } else {
        echo $listenfilepath . ' is not empty, that means a dump job is undergoin\'';
        echo "<br />";
        fclose($listenfile);
        echo "the current prossin' parameter is: " . $futabruh;
        echo "<br />";
        $futabruh = preg_replace('/.*\|/', '', $futabruh);
        echo "and the current prosessin' results could be accessed from <a href=\"results." . $futabruh. ".txt\">here<a>";
        echo "<br />";
        echo "and the final prosessin' results would be uploaded into <a href=\"" . $url . $futabruh . "/results." . $futabruh . ".txt\">here<a>";
    }
?>
